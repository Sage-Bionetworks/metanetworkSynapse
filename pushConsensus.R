###script to grab files from s3, build consensus, push full network and sparsified network to synapse

####INPUTS

###file with synapse ids
###file with code urls
###file with methods to grab
###s3 path

method_file <- commandArgs(TRUE)[[1]]
s3path <- commandArgs(TRUE)[[2]]

method_list <- scan(method_file,what='character')

s3commandConstructor <- function(x,s3path){
  return(paste0('aws s3 cp ',s3path,x,' ./'))
}
cat('copying files from s3 to local directory\n')
foo <- sapply(method_list,s3commandConstructor,s3path)
sapply(foo,system)


require(bit64)
require(dplyr)
cat('loading first file\n')
load(method_list[1])
cat('symmetrisizing first file\n')
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
  cat('loading',str,'\n')
  load(str)
  load('aggregateRank.rda')
  network <- as.matrix(network)
  network <- network+t(network)
  gc()
  b <- network[w1]
  print(b[1:5])
  rm(network)
  gc()
  foo <- rank(-abs(b),ties.method='min') %>% as.integer64
  print(foo[1:5])
  aggregateRank <- aggregateRank + foo
  print(aggregateRank[1:5])
  gc()
  save(aggregateRank,file='aggregateRank.rda')
}

sapply(method_list[-1],internal,whichUpperTri)

#rm(list=ls())
gc()
cat('turning into matrix\n')
#require(bit64)
load('aggregateRank.rda')
finalRank <- rank(-aggregateRank,ties.method = 'min')
finalRank <- finalRank/max(finalRank)

load(method_list[1])
network <- as.matrix(network)
whichUpperTri <- which(upper.tri(network))
whichLowerTri <- which(lower.tri(network))
network[whichUpperTri] <- finalRank
network[whichLowerTri] <- 0
network <- network+t(network)

save(network,file='result_rankConsensus.rda')
str <- paste0('aws s3 mv result_rankConsensus.rda ',s3path)
system(str)
system('rm *.rda')

