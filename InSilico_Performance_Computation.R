# R file to calculate performance metric for In Silico networks 

## It is assumed your working directory is where this file is

## Clear R console screen output
cat("\014")  

## Load required libraries
library(data.table)
library(tidyr)
library(plyr)
library(dplyr)
library(stringr)

library(igraph)
library(ROCR)
library(pracma)
library(Matrix)

library(synapseClient)
library(githubr)

synapseLogin()

## Get gold standard networks from DREAM5 synapse project
GOLD.STD.IDs = c('InSilico1' = 'syn7248256', 'InSilico2' = 'syn7248439')

## Get rank consensus network from synapse
RANK.CONS.IDs = c('InSilico1' = 'syn7291473', 'InSilico2' = 'syn7264583')

## Get bic network from synapse
BIC.IDs = c('InSilico1' = 'syn7291471', 'InSilico2' = 'syn7264579')

# Calculate performance
all.results = mapply(function(gld.std.id, rank.cons.id, bic.id){
  # Get gold standard network from synapse 
  net.edge.gs = read.table(synGet(gld.std.id)@filePath, header=F)
  colnames(net.edge.gs) = c('from','to','weight')
  
  g = igraph::graph_from_data_frame(net.edge.gs)
  
  gs.adj = igraph::as_adjacency_matrix(g, type = 'both') 
  rownames(gs.adj) = V(g)$name
  colnames(gs.adj) = V(g)$name
  
  # Get rank consensus network from synapse
  adj = read.csv(synGet(rank.cons.id)@filePath, header = T, row.names = 1)
  rownames(adj) = gsub('\\.','-', rownames(adj))
  colnames(adj) = gsub('\\.','-', colnames(adj))
  adj = adj[rownames(gs.adj), colnames(gs.adj)]
  
  adj = adj + t(adj)
  gs.adj = gs.adj + t(gs.adj)
  gs.adj[gs.adj > 1] = 1
  
  tmp.adj = as.vector(as.matrix(adj))
  tmp.gs.adj = as.vector(as.matrix(gs.adj))
  
  pred = prediction(tmp.adj, tmp.gs.adj)
  
  auc.raw = performance(pred, measure = 'auc')@y.values[[1]]
  pr = performance(pred, measure = 'prec')@y.values[[1]]
  rc = performance(pred, measure = 'rec')@y.values[[1]]
  aupr.raw = pracma::trapz(rc[!is.na(rc) & !is.na(pr)], pr[!is.na(rc) & !is.na(pr)])
  
  # Get bic network
  load(synGet(bic.id)@filePath)
  adj.bic = bicNetworks$network
  rownames(adj.bic) = gsub('\\.','-', rownames(adj.bic))
  colnames(adj.bic) = gsub('\\.','-', colnames(adj.bic))
  adj.bic = adj.bic[rownames(gs.adj), colnames(gs.adj)]
  adj.bic = as.matrix(adj.bic)
  adj.bic[which(adj.bic == 1)] = data.matrix(adj)[which(adj.bic == 1)]
  adj.bic = adj.bic + t(adj.bic)
  
  tmp.bic.adj = as.vector(as.matrix(adj.bic))
  
  pred = prediction(tmp.bic.adj, tmp.gs.adj)
  
  auc.bic = performance(pred, measure = 'auc')@y.values[[1]]
  pr = performance(pred, measure = 'prec')@y.values[[1]]
  rc = performance(pred, measure = 'rec')@y.values[[1]]
  aupr.bic = pracma::trapz(rc[!is.na(rc) & !is.na(pr)], pr[!is.na(rc) & !is.na(pr)])
  
  tmp.bic.adj[tmp.bic.adj != 0] = 1
  
  return(data.frame(auc.raw = auc.raw, aupr.raw = aupr.raw, 
                    auc.bic = auc.bic, aupr.bic = aupr.bic, 
                    tp = sum(tmp.bic.adj[tmp.gs.adj == 1] == 1),
                    fp = sum(tmp.bic.adj[tmp.gs.adj == 0] == 1),
                    tn = sum(tmp.bic.adj[tmp.gs.adj == 0] == 0),
                    fn = sum(tmp.bic.adj[tmp.gs.adj == 1] == 0)))
}, GOLD.STD.IDs, RANK.CONS.IDs, BIC.IDs, SIMPLIFY = F) %>%
  rbindlist(idcol = 'NetworkName')

all.results = all.results %>% 
  dplyr::mutate(odds = (tp+tn)/(fp + fn))

# Get github commit link
thisRepo <- getRepo(repository = "th1vairam/metanetworkSynapse", 
                    ref="branch", 
                    refName='net_eval')

thisFile <- getPermlink(repository = thisRepo,
                        repositoryPath = 'InSilico_Performance_Computation.R')

# Store results in synapse
all.results[,-(1)] = sapply(all.results[,-(1)], as.numeric)
write.table(all.results, file = 'InSilico_Performance.tsv', row.names = F, sep = '\t')
obj = File('InSilico_Performance.tsv', name = 'InSilico Performance', parentId = 'syn7248617')
obj = synStore(obj, 
               used = as.character(c(BIC.IDs, GENE.MAP.IDs, GOLD.STD.IDs, RANK.CONS.IDs)), 
               executed = thisFile, 
               activityName = 'Estimate performance for InSilico networks')