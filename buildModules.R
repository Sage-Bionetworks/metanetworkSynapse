#!/bin/bash
#### Function to compute modules of weighted bicNetworks from synapse and push results back to synapse ####

#### Get command line arguments as inputs ####
bicNet.id = commandArgs(TRUE)[[1]];#'syn6188448'
rankConsNet.id = commandArgs(TRUE)[[2]];#'syn6188446'

module.method = commandArgs(TRUE)[[3]];#'fast_greedy'
path = commandArgs(TRUE)[[4]];# '/shared/Github/metanetwork/CFinder-2.0.6--1448/' or '/shared/Github/metanetwork/GANXiS_v3.0.2/'

repository = commandArgs(TRUE)[[5]];#'th1vairam/metanetworkSynapse'
branchName = commandArgs(TRUE)[[6]];#'modules_dev'
fileName = commandArgs(TRUE)[[7]];#'getModules.R'  

# apiKey.file = commandArgs(TRUE)[[8]];#'/shared/apikey.txt' 
configPath = commandArgs(TRUE)[[8]];#'/shared/synapseConfig'
library.path = commandArgs(TRUE)[[9]];#'/shared/mylibs'

#### Set library paths ####
.libPaths(library.path)

#### Load Libraries ####
library(data.table)
library(tidyr)
library(plyr)
library(dplyr)

library(igraph)
library(metanetwork)

library(synapseClient)
library(githubr)

library(parallel)
library(doParallel)
library(foreach)

nc = detectCores()
if (nc > 2){
  cl = makeCluster(nc - 2)
} else {
  cl = makeCluster(1)
}
registerDoParallel(cl)

#### Login to synapse ####
synapseLogin(configPath = configPath)

#### Get the latest commit of used files from github ####
thisRepo <- githubr::getRepo(repository = repository, ref = "branch", refName = branchName)
thisFile <- githubr::getPermlink(repository = thisRepo, repositoryPath= 'buildModules.R')

#### Get input data from synapse and formulate and adjacency matrix ####
# Get bicNetworks.rda
bic.obj = synGet(bicNet.id)
load(bic.obj@filePath) # this will load an R object nameds bicNetworks
all.used.ids = bicNet.id # for provenance

# Get rankconsensus network for weights
rank.cons = data.table::fread(synGet(rankConsNet.id)@filePath, data.table = F, header = T)
rownames(rank.cons) = rank.cons$V1
rank.cons$V1 = NULL
all.used.ids = c(all.used.ids, rankConsNet.id)

# Formulate adjacency matrix
adj = rank.cons
adj[!as.matrix(bicNetworks$rankConsensus$network)] = 0
adj = data.matrix(adj)

rm(list = c('bicNetworks', 'rank.cons'))
gc()

#### Compute modules using specified algorithm ####
# Get a specific algorithm
findModules.algo = switch (module.method,
                           CFinder = metanetwork::findModules.CFinder,
                           GANXiS = metanetwork::findModules.GANXiS,
                           edge_betweenness = metanetwork::findModules.edge_betweenness,
                           fast_greedy = metanetwork::findModules.fast_greedy,
                           hclust = metanetwork::findModules.hclust,
                           infomap = metanetwork::findModules.infomap, 
                           label_prop = metanetwork::findModules.label_prop, 
                           leading_eigen = metanetwork::findModules.leading_eigen,
                           linkcommunities = metanetwork::findModules.linkcommunities,
                           louvain = metanetwork::findModules.louvain,
                           spinglass = metanetwork::findModules.spinglass,
                           walktrap = metanetwork::findModules.walktrap)

# Compute modules
if (module.method == 'CFinder'){
  mod = findModules.algo(adj, path = path)
} else if (module.method == 'GANXiS'){
  mod = findModules.algo(adj, path = path)
} else{
  mod <- findModules.algo(adj)
}

# Find modularity quality metrics
NQ = metanetwork::compute.LocalModularity(adj, mod)
Q = metanetwork::compute.Modularity(adj, mod, method = 'Newman1')
Qds = metanetwork::compute.ModularityDensity(adj, mod)
module.qc.metrics = metanetwork::compute.ModuleQualityMetric(adj, mod)

#### Store results in synapse ####
# Create a modules folder
fold = Folder(name = 'Modules', parentId = synGet(bic.obj@properties$parentId, downloadFile = F)@properties$parentId)
fold = synStore(fold)

# Write results to synapse
system(paste('mkdir',bicNet.id))
write.table(mod, file = paste0(bicNet.id,'/',module.method,'.modules.tsv'), row.names=F, quote=F, sep = '\t')
obj = synapseClient::File(paste0(bicNet.id,'/',module.method,'.modules.tsv'), parentId = fold$properties$id)
synapseClient::annotations(obj) = synapseClient::annotations(bic.obj)
obj$annotations$fileType = "tsv"
obj$annotations$analysisType = "moduleIdentification"
obj$annotations$method = module.method
obj$annotations$Q = Q
obj$annotations$NQ = NQ
obj$annotations$Qds = Qds
obj = synapseClient::synStore(obj, used = all.used.ids, executed = thisFile, activityName = 'Module Identification')

write.table(module.qc.metrics, file = paste0(bicNet.id,'/',module.method,'.moduleQCMetrics.tsv'), row.names=F, quote=F, sep = '\t')
obj.qc = synapseClient::File(paste0(bicNet.id,'/',module.method,'.moduleQCMetrics.tsv'), parentId = fold$properties$id)
synapseClient::annotations(obj.qc) = synapseClient::annotations(obj)
obj.qc$annotations$analysisType = "moduleQC"
obj.qc = synapseClient::synStore(obj.qc, activity = synGetActivity(obj))

stopCluster(cl)
