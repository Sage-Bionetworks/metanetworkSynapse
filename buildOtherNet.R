require(metaNet)

fileName <- as.character(commandArgs(TRUE)[[1]])
pathv <- as.character(commandArgs(TRUE)[[2]])
functionName <- as.character(commandArgs(TRUE)[[3]])
pval <- as.character(commandArgs(TRUE)[[4]])
if(pval=='NULL'){
  pval <- NULL
}else{
  pval <- as.numeric(pval)
}
data <- data.matrix(read.csv(fileName,row.names=1))
argList <- list(data=data,path=pathv)
if(functionName=='aracne'){
  installAracne()
  argList$pval <- pval
}
do.call(what=functionName,args=argList)
#sparrowMPI(data,nodes,pathv)
