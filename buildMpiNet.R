require(metaNet)

fileName <- as.character(commandArgs(TRUE)[[1]])
nodes <- as.numeric(commandArgs(TRUE)[[2]])
pathv <- as.character(commandArgs(TRUE)[[3]])
cat(fileName,nodes,pathv,'\n')

functionName <- as.character(commandArgs(TRUE)[[4]])
cat(fileName,nodes,pathv,functionName,'\n')

data <- data.matrix(read.csv(fileName,row.names=1))
do.call(what=mpiWrapper,args=list(data=data,nodes=nodes,pathv=pathv,regressionFunction=functionName))
#sparrowMPI(data,nodes,pathv)
