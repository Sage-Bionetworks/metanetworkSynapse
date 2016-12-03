## Function to build modules from weighted bicNetworks using all 11 algorithms and push results back to synapse

# Load libraries
library(data.table)
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)

library(igraph)
library(metanetwork)

library(synapseClient)
library(githubr)

library(foreach)
library(doParallel)

cl = makeCluster(14)
registerDoParallel(cl)

synapseLogin()

# Get latest commit of the executable from github (for provenance)
thisRepo <- githubr::getRepo(repository = "th1vairam/metanetworkSynapse", ref="branch", refName='modules_dev')
thisFile <- githubr::getPermlink(repository = thisRepo, repositoryPath= 'buildModules.R')

# Synapse parameters
tmp = synQuery('select name,id from file where projectId == "syn5569099"')
net.ids = data.frame(rc.net.ids = tmp$file.id[tmp$file.name == 'rankConsensusNetwork2.csv'],
                     bic.net.ids = tmp$file.id[tmp$file.name == 'bicNetworks2.rda'])
net.ids$NetName = paste0('Net',1:dim(net.ids)[1])
mod.methods = c('CFinder', 'fast_greedy', 'GANXiS', 'hclust', 'infomap', 'label_prop', 
                'leading_eigen', 'linkcommunities', 'louvain', 'spinglass', 'walktrap')

# Run module identification for each network with each method
all.objs = ddply(net.ids, .(NetName), .fun = function(x, mod.methods){
  # Get bic network from synapse
  net.obj = synapseClient::synGet(as.character(x$bic.net.ids))
  load(net.obj@filePath)
  
  # Get rank consensus network from synapse
  rc = read.csv(synGet(as.character(x$rc.net.ids))@filePath, row.names = 1)
  rc[which(!(bicNetworks$network),arr.ind = T)] = 0
  
  # Get the adjacency matrix
  adj <- data.matrix(rc)
  
  objs = foreach::foreach(method=mod.methods, .packages = c('metanetwork', 'synapseClient'), .combine = c) %dopar% {
    find.modules <- switch(method,
                           CFinder = metanetwork::findModules.CFinder,
                           fast_greedy = metanetwork::findModules.fast_greedy,
                           GANXiS = metanetwork::findModules.GANXiS,
                           hclust = metanetwork::findModules.hclust,
                           infomap = metanetwork::findModules.infomap, 
                           label_prop = metanetwork::findModules.label_prop, 
                           leading_eigen = metanetwork::findModules.leading_eigen,
                           linkcommunities = metanetwork::findModules.linkcommunities,
                           louvain = metanetwork::findModules.louvain,
                           spinglass = metanetwork::findModules.spinglass,
                           walktrap = metanetwork::findModules.walktrap)
    
    if (method == 'CFinder'){
      mod = find.modules(adj, path = '/mnt/Github/metanetwork/CFinder-2.0.6--1448/')
    } else if (method == 'GANXiS'){
      mod = find.modules(adj, '/mnt/Github/metanetwork/GANXiS_v3.0.2/')
    } else{
      mod = find.modules(adj)
    }
    
    NQ = metanetwork::compute.LocalModularity(adj, mod)
    Q = metanetwork::compute.Modularity(adj, mod, method = 'Newman1')
    Qds = metanetwork::compute.ModularityDensity(adj, mod)
    
    # Write results to synapse
    write.table(mod, file = paste0(method,'.modules.tsv'), row.names=F, quote=F, sep = '\t')
    obj = synapseClient::File(paste0(method,'.modules.tsv'), 
                              name = paste('Modules',method), parentId = net.obj@properties$parentId)
    synapseClient::annotations(obj) = list('algorithm' = method,
                                           'Q' = Q,
                                           'NQ' = NQ,
                                           'Qds' = Qds,
                                           'fileType' = 'tsv',
                                           'resultsType' = 'modules')
    obj = synapseClient::synStore(obj, 
                                  used = c(as.character(x$rc.net.ids), as.character(x$bic.net.ids)), 
                                  executed = thisFile, 
                                  activityName = 'Module Identification')
    
    print(paste('Completed', method))
    return(obj$properties$id)
  }
}, mod.methods, .parallel = T)
stopCluster(cl)