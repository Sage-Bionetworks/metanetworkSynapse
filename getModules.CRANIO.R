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
thisFile <- githubr::getPermlink(repository = thisRepo, repositoryPath= 'getModules.CRANIO.R')

# Get all bicNetworks.rda from the source project
BIC_ID = 'syn7342818'

mod.methods = c('fast_greedy', 'infomap', 'label_prop', 'walktrap',
                'louvain', 'leading_eigen')

method = mod.methods[1]
bic.id = BIC_ID

# Perform module identification
all.objs <- lapply(mod.methods, function(method, bic.id){
  findModules.algo = switch (method,
                             fast_greedy = metanetwork::findModules.fast_greedy,
                             infomap = metanetwork::findModules.infomap,
                             label_prop = metanetwork::findModules.label_prop,
                             walktrap = metanetwork::findModules.walktrap,
                             louvain = metanetwork::findModules.louvain,
                             leading_eigen = metanetwork::findModules.leading_eigen,
                             spinglass = metanetwork::findModules.spinglass)
  
  # Get network from synapse
  net.obj = synapseClient::synGet(bic.id)
  load(net.obj@filePath)
    
  # Get the adjacency matrix
  adj <- bicNetworks$network
  
  # Get modules
  mod <- findModules.algo(adj)
    
  # Find modularity (Q) of the network
  Q <- metanetwork::compute.Modularity(adj, mod, method = 'Newman1')
    
  # Write results to synapse
  algo = paste('igraph',method,sep='.')
  write.table(mod, file = paste0(algo,'.modules.tsv'), row.names=F, quote=F, sep = '\t')
  obj = synapseClient::File(paste0(algo,'.modules.tsv'), name = paste('Modules',algo), parentId = net.obj@properties$parentId)
  synapseClient::annotations(obj) = list('algorithm' = algo,
                                         'Q' = Q,
                                         'fileType' = 'tsv',
                                         'resultsType' = 'modules')
  obj = synapseClient::synStore(obj, used = net.obj, executed = thisFile, activityName = 'Module Identification')
  
  print(paste('Completed', method))
}, BIC_ID)