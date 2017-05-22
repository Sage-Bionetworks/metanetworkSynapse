#!/bin/bash
#### Function to identify regulators based on weighted bicNetworks and differential expression results from synapse and push results back to synapse ####

#### Get command line arguments as inputs ####
bicNet.id = 'syn8281722'
rankConsNet.id = 'syn8281727'

module.method = 'CFinder'
path = '/mnt/Github/metanetwork/CFinder-2.0.6--1448/'

repository = 'th1vairam/metanetworkSynapse'
branchName = 'modules_dev'
fileName = 'buildModules.R'  

# apiKey.file = commandArgs(TRUE)[[8]];#'/shared/apikey.txt' 
configPath = '/home/rstudio/.synapseConfig'
library.path = '/mnt/mylibs'

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
# Get a specific algorithm
CFinder = metanetwork::findModules.CFinder(adj, '/mnt/Github/metanetwork/CFinder-2.0.6--1448/', nperm = 3, min.module.size = 30)
GANXiS = metanetwork::findModules.GANXiS(adj, '/mnt/Github/metanetwork/GANXiS_v3.0.2/', nperm = 3, min.module.size = 30)
fast_greedy = metanetwork::findModules.fast_greedy(adj, nperm = 3, min.module.size = 30)
label_prop = metanetwork::findModules.label_prop(adj, nperm = 3, min.module.size = 30)
louvain = metanetwork::findModules.louvain(adj, nperm = 3, min.module.size = 30)
walktrap = metanetwork::findModules.walktrap(adj, nperm = 3, min.module.size = 30)
infomap = metanetwork::findModules.infomap(adj, nperm = 3, min.module.size = 30)
linkcommunities = metanetwork::findModules.linkcommunities(adj, nperm = 3, min.module.size = 30)
spinglass = metanetwork::findModules.spinglass(adj, nperm = 3, min.module.size = 30)
