require(metaNet)

fileName <- as.character(commandArgs(TRUE)[[1]])
pathv <- as.character(commandArgs(TRUE)[[2]])
functionName <- as.character(commandArgs(TRUE)[[3]])
data <- data.matrix(read.csv(fileName,row.names=1))
if(functionName=='aracne'){
  installAracne()
}
do.call(what=functionName,args=list(data=data,path=pathv))
#sparrowMPI(data,nodes,pathv)
