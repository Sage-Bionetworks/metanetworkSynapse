###script to grab files from s3, build consensus, push full network and sparsified network to synapse

####INPUTS

###file with synapse ids
###file with code urls
###file with methods to grab
###s3 path

synFile <- commandArgs(TRUE)[[1]]
codeFile <- commandArgs(TRUE)[[2]]
method <- commandArgs(TRUE)[[3]]
s3path <- commandArgs(TRUE)[[4]]

synFiles <- scan(synFile,what='character')
codeFiles <- scan(codeFile,what='character')
methods <- scan(method,what='character')

s3commandConstructor <- function(x,s3path){
  return(paste0('aws s3 cp ',s3path,x,' ./'))
}

foo <- sapply(methods,s3commandConstructor,s3path)
sapply(foo,system)


require(bit64)
require(dplyr)
load('result_sparrowZ.rda')
network <- as.matrix(network)
network <- network+t(network)
gc()
whichUpperTri <- which(upper.tri(network))
gc()
b <- network[whichUpperTri]
rm(network)
gc()
foo <- rank(-abs(b),ties.method='min')
aggregateRank <- foo %>% as.integer64
gc()
save(aggregateRank,file='aggregateRank.rda')


internal <- function(str,w1){
  cat(str,'\n')
  load(str)
  load('aggregateRank.rda')
  network <- as.matrix(network)
  network <- network+t(network)
  gc()
  b <- network[w1]
  rm(network)
  gc()
  foo <- rank(-abs(b),ties.method='min') %>% as.integer64
  aggregateRank <- aggregateRank + foo
  gc()
  save(aggregateRank,file='aggregateRank.rda')
}

methods <- c('result_lassoAIC.rda','result_lassoBIC.rda','result_lassoCV1se.rda','result_lassoCVmin.rda','result_ridgeAIC.rda','result_ridgeBIC.rda','result_ridgeCV1se.rda','result_ridgeCVmin.rda','result_sparrow2Z.rda','result_elasticNetAIC.rda','result_elasticNetBIC.rda','result_elasticNetCV1se.rda','result_elasticNetCVmin.rda')

sapply(methods,internal,whichUpperTri)

rm(list=ls())
gc()

load('aggregateRank.rda')
finalRank <- rank(-aggregateRank,ties.method = 'min')
finalRank <- finalRank/max(finalRank)

load('result_lassoAIC.rda')
network <- as.matrix(network)
whichUpperTri <- which(upper.tri(network))
whichLowerTri <- which(lower.tri(network))
network[whichUpperTri] <- finalRank
network[whichLowerTri] <- 0
network <- network+t(network)

save(network,file='result_rankConsensus.rda')
str <- paste0('aws s3 mv result_rankConsensus.rda ',s3path)


