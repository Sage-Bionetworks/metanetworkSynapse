## Module test with 100 gene network
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

library(foreach)
library(doParallel)

cl = makeCluster(2)
registerDoParallel(cl)

synapseLogin()

# Synapse parameters
rc.net.id = 'syn7499788'
bic.net.id = 'syn7805122'

# Get bic network from synapse
net.obj = synapseClient::synGet(bic.net.id)
load(net.obj@filePath)

# Get rank consensus network from synapse
rc = read.csv(synGet(rc.net.id)@filePath, row.names = 1)
rc[which(!(bicNetworks$network),arr.ind = T)] = 0

# Get the adjacency matrix
adj <- data.matrix(rc)

# Perform module identification
mod1 = findModules.CFinder(adj, path = '/mnt/Github/metanetwork/CFinder-2.0.6--1448/')
# mod2 = findModules.edge_betweenness(adj)
mod3 = findModules.fast_greedy(adj)
mod4 = findModules.GANXiS(adj, '/mnt/Github/metanetwork/GANXiS_v3.0.2/')
mod5 = findModules.hclust(adj)
mod6 = findModules.infomap(adj)
mod7 = findModules.label_prop(adj)
mod8 = findModules.leading_eigen(adj)
mod9 = findModules.linkcommunities(adj, min.module.size = 0)
mod10 = findModules.louvain(adj)
mod11 = findModules.spinglass(adj)
mod12 = findModules.walktrap(adj)

NQ = compute.LocalModularity(adj, mod3)
Q = compute.Modularity(adj, mod3, method = 'Newman1')
Q = compute.Modularity(adj, mod3, method = 'Newman2')
Qds = compute.ModularityDensity(adj, mod3)
MC = compute.ModuleQualityMetric(adj, mod3)
