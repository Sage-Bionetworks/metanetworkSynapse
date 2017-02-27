# R file to calculate performance metric for DREAM 5 networks 

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
GOLD.STD.IDs = c('InSilico' = 'syn2787240', 'SAureus' = 'syn2787242', 'EColi' = 'syn2787243', 'SCerevisiae' = 'syn2787244')

## Get gene id mapping from DREAM5 synapse project
GENE.MAP.IDs = c('InSilico' = 'syn2787224', 'SAureus' = 'syn2787228', 'EColi' = 'syn2787232', 'SCerevisiae' = 'syn2787236')

## Get rank consensus network from synapse
RANK.CONS.IDs = c('InSilico' = 'syn7291746', 'SAureus' = 'syn7268441', 'EColi' = 'syn7301787', 'SCerevisiae' = 'syn7301801')

## Get bic network from synapse
BIC.IDs = c('InSilico' = 'syn7291744', 'SAureus' = 'syn7268438', 'EColi' = 'syn7301783', 'SCerevisiae' = 'syn7301799')

# Calculate performance
all.results = mapply(function(gld.std.id, gene.map.id, rank.cons.id, bic.id){
  # Get gold standard network from synapse 
  net.edge.gs = read.table(synGet(gld.std.id)@filePath, header=F) %>%
    filter(V3 == 1)
  colnames(net.edge.gs) = c('from','to','weight')
  
  net.vert.gs = read.table(synGet(gene.map.id)@filePath, header = F)
  colnames(net.vert.gs) = c('name','Gene.ID')
  
  g = igraph::graph_from_data_frame(net.edge.gs, vertices = net.vert.gs)
  
  gs.adj = igraph::as_adjacency_matrix(g, type = 'both') 
  rownames(gs.adj) = V(g)$Gene.ID
  colnames(gs.adj) = V(g)$Gene.ID
  
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
  
  roc.raw = performance(pred, measure = 'tpr', x.measure = 'fpr')
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
  
  roc.bic = performance(pred, measure = 'tpr', x.measure = 'fpr')
  auc.bic = performance(pred, measure = 'auc')@y.values[[1]]
  pr = performance(pred, measure = 'prec')@y.values[[1]]
  rc = performance(pred, measure = 'rec')@y.values[[1]]
  aupr.bic = pracma::trapz(rc[!is.na(rc) & !is.na(pr)], pr[!is.na(rc) & !is.na(pr)])
  
  tmp.bic.adj[tmp.bic.adj != 0] = 1

  return(list(performance = data.frame(auc.raw = auc.raw, aupr.raw = aupr.raw, 
                                       auc.bic = auc.bic, aupr.bic = aupr.bic, 
                                       tp = sum(tmp.bic.adj[tmp.gs.adj == 1] == 1)/2,
                                       fp = sum(tmp.bic.adj[tmp.gs.adj == 0] == 1)/2,
                                       tn = sum(tmp.bic.adj[tmp.gs.adj == 0] == 0)/2,
                                       fn = sum(tmp.bic.adj[tmp.gs.adj == 1] == 0)/2),
              roc.raw = roc.raw,
              roc.bic = roc.bic))
}, GOLD.STD.IDs, GENE.MAP.IDs, RANK.CONS.IDs, BIC.IDs, SIMPLIFY = F)

pdf(file = 'ROCPlots.pdf', width = 10, height = 10)
for (i in 1:4){
  plot(all.results[[i]]$roc.raw); 
  par(new=TRUE);
  plot(all.results[[i]]$roc.bic, main = paste('DREAM5', names(all.results)[i]))
}
dev.off()

all.performance = lapply(all.results, function(x){
  x = x$performance
  x$mcc = (x$tp*x$tn - x$fp*x$fn)/(sqrt((x$tp+x$fn)*(x$tn+x$fp)*(x$tp+x$fp)*(x$tn+x$fn)))
  x$odds = (x$tp+x$tn)/(x$fp + x$fn)
  return(x)
}) %>% 
  rbindlist(idcol = 'NetworkName') %>%
  data.frame()

# Get github commit link
thisRepo <- getRepo(repository = "th1vairam/metanetworkSynapse", 
                    ref="branch", 
                    refName='net_eval')

thisFile <- getPermlink(repository = thisRepo,
                        repositoryPath = 'DREAM5_Performance_Computation.R')

# Store results in synapse
all.performance[,-(1)] = sapply(all.performance[,-(1)], as.numeric)
write.table(all.performance, file = 'DREAM5_Performance.tsv', row.names = F, sep = '\t')
obj = File('DREAM5_Performance.tsv', name = 'DREAM5 Performance', parentId = 'syn7248617')
obj = synStore(obj, 
               used = as.character(c(BIC.IDs, GENE.MAP.IDs, GOLD.STD.IDs, RANK.CONS.IDs)), 
               executed = thisFile, 
               activityName = 'Estimate performance for DREAM5 networks')

obj = File('ROCPlots.pdf', name = 'DREAM5 ROC', parentId = 'syn7248617')
obj = synStore(obj, 
               used = as.character(c(BIC.IDs, GENE.MAP.IDs, GOLD.STD.IDs, RANK.CONS.IDs)), 
               executed = thisFile, 
               activityName = 'Estimate performance for DREAM5 networks')