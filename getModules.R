# Function to get bicNetworks from synapse and find modules and push results back to synapse

# Load libraries
library(data.table)
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)

library(igraph)
library(metanetwork)

library(synapseClient)
library(knitr)
library(githubr)

synapseLogin()

# Get latest commit of the executable from github (for provenance)
thisRepo <- githubr::getRepo(repository = "th1vairam/metanetworkSynapse", ref="branch", refName='modules_dev')
thisFile <- githubr::getPermlink(repository = thisRepo, repositoryPath= 'getModules.R')

# Synapse parameters
SOURCE.PROJ_ID = 'syn5569099'

# Get all bicNetworks.rda from the source project
all.bic.neworks <- synQuery(paste0('select id,name from file where projectId == "',SOURCE.PROJ_ID,'"')) %>%
  filter(file.name == "bicNetworks.rda")

mod.methods = c('fast_greedy', 'infomap', 'label_prop', 'walktrap',
                'louvain', 'leading_eigen', 'spinglass')
  
# Perform module identification
all.objs <- lapply(mod.methods, function(method, all.bic.neworks){
  findModules.algo = switch (method,
    fast_greedy = metanetwork::findModules.fast_greedy,
    infomap = metanetwork::findModules.infomap,
    label_prop = metanetwork::findModules.label_prop,
    walktrap = metanetwork::findModules.walktrap,
    louvain = metanetwork::findModules.louvain,
    leading_eigen = metanetwork::findModules.leading_eigen,
    spinglass = metanetwork::findModules.spinglass
  )
  
  objs <- lapply(all.bic.neworks$file.id, function(net.id, findModules.algo, algo){
    # Get network from synapse
    net.obj = synapseClient::synGet(net.id)
    load(net.obj@filePath)

    # Get the adjacency matrix
    adj <- bicNetworks$network
    browser()
    # Get modules
    mod <- findModules.algo(adj)

    # Find modularity (Q) of the network
    g <- igraph::graph.adjacency(adj, weighted = NULL, mode = 'upper', diag = FALSE)
    Q <- igraph::modularity(g, mod[igraph::V(g)$name, 'moduleNumber']+1)

    # Write results to synapse
    write.table(mod, file = paste0(algo,'.modules.tsv'), row.names=F, quote=F, sep = '\t')
    obj = synapseClient::File(paste0(algo,'.modules.tsv'), name = paste('Modules',algo), parentId = net.obj@properties$parentId)
    synapseClient::annotations(obj) = list('algorithm' = algo,
                                           'Q' = Q,
                                           'fileType' = 'tsv',
                                           'resultsType' = 'modules')
    obj = synapseClient::synStore(obj, used = net.obj, executed = thisFile, activityName = 'Module Identification')
  }, 
  findModules.algo, paste('igraph',method,sep='.'))
  print(paste('Completed', method))
}, all.bic.neworks)