#!/bin/bash
#### Function to compute consensus module from individual module methods stored in synapse and push results back to synapse ####

#### Get command line arguments as inputs ####
args = commandArgs(TRUE)
cons.method = args[1];#'kmeans'
run.id = args[2];#1

repository = args[3];#'th1vairam/metanetworkSynapse'
branchName = args[4];#'modules_dev'
fileName = args[5];#'buildConsensusModules.R'  

configPath = args[6];#'/home/rstudio/.synapseConfig'
library.path = args[7];#'/mnt/mylibs'

bicNet.id = args[8];#'syn8268669'
rankConsNet.id = args[9];#'syn8268680'

modules.id = args[10:length(args)]; # c(	"syn9875861", "syn9875878", "syn9875884", "syn9944757", "syn9944761", "syn9944765", "syn9944773", "syn9944777", "syn9944782", "syn9944786", 
                # "syn9944791", "syn9944792", "syn9944797", "syn9944801", "syn9944805", "syn9944809", "syn9944813", "syn9944821", "syn9944833", "syn9945203", 
                # "syn9875920", "syn9877858", "syn9877867", "syn9944874", "syn9944878", "syn9944884", "syn9944885", "syn9944890", "syn9944896", "syn9944898", 
                # "syn9944904", "syn9944906", "syn9944910", "syn9944914", "syn9944918", "syn9944922", "syn9944926", "syn9944930", "syn9944934", "syn9944938", 
                # "syn9875898", "syn9877893", "syn9877904", "syn9944837", "syn9944847", "syn9944857", "syn9945154", "syn9945170", "syn9945214", "syn9945230", 
                # "syn9945284", "syn9945328", "syn9945390", "syn9945406", "syn9945430", "syn9945516", "syn9945550", "syn9945580", "syn9945604", "syn9945649", 
                # "syn9876084", "syn9877873", "syn9877887", "syn9945183", "syn9945218", "syn9945246", "syn9945268", "syn9945312", "syn9945340", "syn9945378", 
                # "syn9945415", "syn9945454", "syn9945488", "syn9945504", "syn9945554", "syn9945572", "syn9945612", "syn9945661", "syn9945674", "syn9945707", 
                # "syn9875916", "syn9875939", "syn9875954", "syn9944948", "syn9944958", "syn9944962", "syn9944966", "syn9944970", "syn9944977", "syn9944981", 
                # "syn9944983", "syn9944989", "syn9944990", "syn9944995", "syn9944999", "syn9945003", "syn9945007", "syn9945011", "syn9945015", "syn9945386", 
                # "syn9877766", "syn9881863", "syn9875960", "syn9875964", "syn9875968", "syn9945031", "syn9945035", "syn9945039", "syn9945043", "syn9945272", 
                # "syn9945304", "syn9945346", "syn9945382", "syn9945410", "syn9945440", "syn9945493", "syn9945524", "syn9945541", "syn9945588", "syn9945624", 
                # "syn9945641", "syn9876141", "syn9945260", "syn9945332", "syn9945352", "syn9945370", "syn9945398", "syn9945446", "syn9945462", "syn9945484", 
                # "syn9945532", "syn9945562", "syn9945576", "syn9945645", "syn9945653", "syn9945695", "syn9945715", "syn9945735", "syn9945769", "syn9945808", 
                # "syn9945825", "syn9875997", "syn9876014", "syn9876021", "syn9945121", "syn9945162", "syn9945195", "syn9945222", "syn9945250", "syn9945288", 
                # "syn9945320", "syn9945356", "syn9945394", "syn9945426", "syn9945458", "syn9945500", "syn9945528", "syn9945558", "syn9945600", "syn9945628", 
                # "syn9945657")

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
all.used.ids = c(all.used.ids, modules.id)

partition.adj = mapply(function(mod, method){
  mod = mod %>%
    dplyr::select(Gene.ID, moduleNumber) %>%
    dplyr::mutate(value = 1,
                  moduleNumber = paste0(method,'.',moduleNumber)) %>%
    tidyr::spread(moduleNumber, value)
}, partition.adj, names(partition.adj), SIMPLIFY = F) %>%
  join_all()
partition.adj[is.na(partition.adj)] = 0
rownames(partition.adj) = partition.adj$Gene.ID
partition.adj$Gene.ID = NULL

# Randomise gene order
partition.adj = partition.adj[sample(1:dim(partition.adj)[1], dim(partition.adj)[1]), ]

#### Compute consensus modules using specified algorithm ####
# Compute consensus modules nreps and choose the best solution
mod <- metanetwork::findModules.consensusCluster(d = t(partition.adj), maxK = 100, reps = 50, pItem = 0.8, pFeature = 1,
                                                 clusterAlg = cons.method, innerLinkage = "average", distance = "pearson",
                                                 changeCDFArea = 0.001, nbreaks = 10, seed = 123456789.12345,
                                                 weightsItem = NULL, weightsFeature = NULL, corUse = "everything",
                                                 verbose = F)

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

# Create a consensus modules folder
fold1 = Folder(name = 'consensus_kmeans', parentId = fold@properties$id)
fold1 = synStore(fold1)

# Write results to synapse
system(paste('mkdir',bicNet.id))
write.table(mod, file = paste0(bicNet.id,'/Consensus.',cons.method,'.',run.id,'.modules.tsv'), row.names=F, quote=F, sep = '\t')
obj = synapseClient::File(paste0(bicNet.id,'/Consensus.',cons.method,'.',run.id,'.modules.tsv'), parentId = fold1$properties$id)
synapseClient::annotations(obj) = synapseClient::annotations(bic.obj)
obj$annotations$fileType = "tsv"
obj$annotations$analysisType = "consensusModuleIdentification"
obj$annotations$method = cons.method
obj$annotations$Q = Q
obj$annotations$NQ = NQ
obj$annotations$Qds = Qds
obj$annotations$columnScaled = TRUE
obj$annotations$winsorized = TRUE 
obj$annotations$deprecated = FALSE
obj = synapseClient::synStore(obj, used = all.used.ids, executed = thisFile, activityName = 'Consensus Module Identification')

write.table(module.qc.metrics, file = paste0(bicNet.id,'/Consensus.',cons.method,'.',run.id,'.moduleQCMetrics.tsv'), row.names=F, quote=F, sep = '\t')
obj.qc = synapseClient::File(paste0(bicNet.id,'/Consensus.',cons.method,'.',run.id,'.moduleQCMetrics.tsv'), parentId = fold1$properties$id)
synapseClient::annotations(obj.qc) = synapseClient::annotations(obj)
obj.qc$annotations$analysisType = "moduleQC"
obj.qc = synapseClient::synStore(obj.qc, activity = synGetActivity(obj))

stopCluster(cl)