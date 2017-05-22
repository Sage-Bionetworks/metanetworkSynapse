#!/bin/bash
#### Function to compute modules of weighted bicNetworks from synapse and push results back to synapse ####

#### Get command line arguments as inputs ####
bicNet.id = commandArgs(TRUE)[[1]];#'syn8268669'
rankConsNet.id = commandArgs(TRUE)[[2]];#'syn8268680'

module.method = commandArgs(TRUE)[[3]];#'fast_greedy'
path = commandArgs(TRUE)[[4]];#'/shared/Github/metanetwork/CFinder-2.0.6--1448/' or '/shared/Github/metanetwork/GANXiS_v3.0.2/'
runId = commandArgs(TRUE)[[5]];#'1'

repository = commandArgs(TRUE)[[6]];#'th1vairam/metanetworkSynapse'
branchName = commandArgs(TRUE)[[7]];#'modules_dev'
fileName = commandArgs(TRUE)[[8]];#'buildModules.R'  

configPath = commandArgs(TRUE)[[9]];#'/home/rstudio/synapseConfig'
library.path = commandArgs(TRUE)[[10]];#'/mnt/mylibs'

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
thisFile <- githubr::getPermlink(repository = thisRepo, repositoryPath= fileName)

#### Get input data from synapse and formulate adjacency matrix ####
# Get bicNetworks.rda
bic.obj = synGet(bicNet.id)
load(bic.obj@filePath) # this will load an R object nameds bicNetworks
all.used.ids = bicNet.id # for provenance
writeLines(paste('Total number of edges', sum(as.matrix(bicNetworks$network))))

# Get rankconsensus network for weights
rank.cons = data.table::fread(synGet(rankConsNet.id)@filePath, data.table = F, header = T)
rownames(rank.cons) = rank.cons$V1
rank.cons$V1 = NULL
all.used.ids = c(all.used.ids, rankConsNet.id)

# Formulate adjacency matrix
adj = rank.cons
adj[!as.matrix(bicNetworks$network)] = 0
adj = data.matrix(adj)

rm(list = c('bicNetworks', 'rank.cons'))
gc()

#### Compute modules using specified algorithm ####
# Compute modules
mod = switch (module.method,
              CFinder = metanetwork::findModules.CFinder(adj, path = path, nperm = 10, min.module.size = 30),
              GANXiS = metanetwork::findModules.GANXiS(adj, path = path, nperm = 10, min.module.size = 30),
              fast_greedy = metanetwork::findModules.fast_greedy(adj, nperm = 10, min.module.size = 30),
              label_prop = metanetwork::findModules.label_prop(adj, nperm = 10, min.module.size = 30), 
              louvain = metanetwork::findModules.louvain(adj, nperm = 10, min.module.size = 30),
              spinglass = metanetwork::findModules.spinglass(adj, nperm = 10, min.module.size = 30),
              walktrap = metanetwork::findModules.walktrap(adj, nperm = 10, min.module.size = 30),
              infomap = metanetwork::findModules.infomap(adj, nperm = 10, min.module.size = 30), 
              linkcommunities = metanetwork::findModules.linkcommunities(adj, nperm = 10, min.module.size = 30))

# Find modularity quality metrics
mod = as.data.frame(mod)
rownames(mod) = mod$Gene.ID
mod = mod[rownames(adj),]
NQ = metanetwork::compute.LocalModularity(adj, mod)
Q = metanetwork::compute.Modularity(adj, mod, method = 'Newman1')
Qds = metanetwork::compute.ModularityDensity(adj, mod)
module.qc.metrics = metanetwork::compute.ModuleQualityMetric(adj, mod)

#### Store results in synapse ####
# Create a modules folder
fold = Folder(name = 'Modules', parentId = synGet(bic.obj@properties$parentId, downloadFile = F)@properties$parentId)
fold = synStore(fold)

# Create a methods folder
fold1 = Folder(name = module.method, parentId = fold@properties$parentId)
fold1 = synStore(fold1)

# Write results to synapse
system(paste('mkdir',bicNet.id))
write.table(mod, file = paste0(bicNet.id,'/',module.method,'.',runId,'.modules.tsv'), row.names=F, quote=F, sep = '\t')
obj = synapseClient::File(paste0(bicNet.id,'/',module.method,'.',runId,'.modules.tsv'), parentId = fold1$properties$id)
synapseClient::annotations(obj) = synapseClient::annotations(bic.obj)
obj$annotations$fileType = "tsv"
obj$annotations$analysisType = "moduleIdentification"
obj$annotations$method = module.method
obj$annotations$Q = Q
obj$annotations$NQ = NQ
obj$annotations$Qds = Qds
obj = synapseClient::synStore(obj, used = all.used.ids, executed = thisFile, activityName = 'Module Identification')

write.table(module.qc.metrics, file = paste0(bicNet.id,'/',module.method,'.',runId,'.moduleQCMetrics.tsv'), row.names=F, quote=F, sep = '\t')
obj.qc = synapseClient::File(paste0(bicNet.id,'/',module.method,'.',runId,'.moduleQCMetrics.tsv'), parentId = fold1$properties$id)
synapseClient::annotations(obj.qc) = synapseClient::annotations(obj)
obj.qc$annotations$analysisType = "moduleQC"
obj.qc = synapseClient::synStore(obj.qc, activity = synGetActivity(obj))

stopCluster(cl)