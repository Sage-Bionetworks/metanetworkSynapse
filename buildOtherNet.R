require(metanetwork)

fileName <- as.character(commandArgs(TRUE)[[1]])
pathv <- as.character(commandArgs(TRUE)[[2]])
functionName <- as.character(commandArgs(TRUE)[[3]])
pval <- as.character(commandArgs(TRUE)[[4]])
outputpath <- as.character(commandArgs(TRUE)[[5]])
if(pval=='NULL'){
  pval <- NULL
}else{
  pval <- as.numeric(pval)
}
data <- data.matrix(read.csv(fileName,row.names=1))
argList <- list(data=data,path=pathv,outputpath=outputpath)
if(functionName=='aracne' | functionName=='mrnetWrapper'){
  installAracne(path=pathv)
  argList$pval <- pval
}
do.call(what=functionName,args=argList)
#sparrowMPI(data,nodes,pathv)
