require(metanetwork)
library(reader)

fileName <- as.character(commandArgs(TRUE)[[1]])
nodes <- as.numeric(commandArgs(TRUE)[[2]])
pathv <- as.character(commandArgs(TRUE)[[3]])
cat(fileName,nodes,pathv,'\n')

functionName <- as.character(commandArgs(TRUE)[[4]])
cat(fileName,nodes,pathv,functionName,'\n')

outputpath <- as.character(commandArgs(TRUE)[[5]])

data <- data.matrix(reader(fileName,row.names=1))
do.call(what=mpiWrapper,args=list(data=data,nodes=nodes,pathv=pathv,regressionFunction=functionName,outputpath=outputpath))
#sparrowMPI(data,nodes,pathv)
