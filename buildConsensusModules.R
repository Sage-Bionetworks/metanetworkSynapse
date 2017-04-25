#!/bin/bash
#### Function to compute consensus module from individual module methods stored in synapse and push results back to synapse ####

#### Get command line arguments as inputs ####
args = commandArgs(TRUE)
cons.method = args[1];#'kmeans'

repository = args[2];#'th1vairam/metanetworkSynapse'
branchName = args[3];#'modules_dev'
fileName = args[4];#'buildConsensusModules.R'  

configPath = args[5];#'/shared/synapseConfig'
library.path = args[6];#'/shared/mylibs'

bicNet.id = args[7];#'syn6188448'
rankConsNet.id = args[[8]];#'syn6188446'

modules.id = args[9:length(args)];#'syn8399110'

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
synapseLogin()

#### Get the latest commit of used files from github ####
thisRepo <- githubr::getRepo(repository = repository, ref = "branch", refName = branchName)
thisFile <- githubr::getPermlink(repository = thisRepo, repositoryPath= fileName)

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
adj[!as.matrix(bicNetworks$network)] = 0
adj = data.matrix(adj)

rm(list = c('bicNetworks', 'rank.cons'))
gc()

#### Get individual partitions from synapse and formulate partition adjacency matrix ####
partition.adj = lapply(modules.id, function(id){
  fread(synGet(id)@filePath, header = T, data.table =F)
})
names(partition.adj) = paste0('Method', 1:length(partition.adj))

partition.adj = mapply(function(mod, method){
  mod = mod %>%
    dplyr::select(Gene.ID, moduleNumber) %>%
    dplyr::mutate(value = 1,
                  moduleNumber = paste0(method,moduleNumber)) %>%
    tidyr::spread(moduleNumber, value)
}, partition.adj, names(partition.adj), SIMPLIFY = F) %>%
  join_all()
partition.adj[is.na(partition.adj)] = 0
rownames(partition.adj) = partition.adj$Gene.ID
partition.adj$Gene.ID = NULL

#### Compute consensus modules using specified algorithm ####
# Get a specific algorithm
findModules.algo = switch (cons.method,
                           kmeans = metanetwork::findModules.consensusKmeans)

# Compute consensus modules
mod <- findModules.algo(data.matrix(partition.adj), min.module.size = 20, usepam = FALSE)

# Find modularity quality metrics
mod = mod[rownames(adj),]
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
write.table(mod, file = paste0(bicNet.id,'/Consensus.',cons.method,'.modules.tsv'), row.names=F, quote=F, sep = '\t')
obj = synapseClient::File(paste0(bicNet.id,'/Consensus.',cons.method,'.modules.tsv'), parentId = fold$properties$id)
synapseClient::annotations(obj) = synapseClient::annotations(bic.obj)
obj$annotations$fileType = "tsv"
obj$annotations$analysisType = "consensusModuleIdentification"
obj$annotations$method = cons.method
obj$annotations$Q = Q
obj$annotations$NQ = NQ
obj$annotations$Qds = Qds
obj = synapseClient::synStore(obj, used = all.used.ids, executed = thisFile, activityName = 'Consensus Module Identification')

write.table(module.qc.metrics, file = paste0(bicNet.id,'/Consensus.',cons.method,'.moduleQCMetrics.tsv'), row.names=F, quote=F, sep = '\t')
obj.qc = synapseClient::File(paste0(bicNet.id,'/Consensus.',cons.method,'.moduleQCMetrics.tsv'), parentId = fold$properties$id)
synapseClient::annotations(obj.qc) = synapseClient::annotations(obj)
obj.qc$annotations$analysisType = "moduleQC"
obj.qc = synapseClient::synStore(obj.qc, activity = synGetActivity(obj))

stopCluster(cl)
