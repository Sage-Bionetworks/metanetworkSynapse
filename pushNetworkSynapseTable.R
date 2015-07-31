#push networks to Synapse table.

require(synapseClient)
synapseLogin()
require(metanetwork)
require(dplyr)
require(data.table)

projectId <- as.character(commandArgs(TRUE)[[1]])
tableName <- as.character(commandArgs(TRUE)[[2]])
networkFiles <- as.character(commandArgs(TRUE)[[3]])
nGenes <- as.numeric(commandArgs(TRUE)[[4]])

projectId <- 'syn3455058'
tableName <- 'Schizophrenia Network Edges'
networkFiles <- 'edgeFiles.txt'
nGenes <- 16423

netFiles <- scan(networkFiles,what='character')

methodNames <- sapply(netFiles,function(x) return(strsplit(x,'_')[[1]][1]))

allNetworks <- lapply(netFiles,function(char){x <- fread(char);gc();return(x);})
generateMasterEdgeNames <- function(n){
  mat <- cbind(rep(1:n,n), unlist(lapply(1:n,function(x,y) return(rep(x,y)),n)))
  keep <- mat[,2]>mat[,1]
  res <- list()
  res$names <- paste0(mat[keep,1],'_',mat[keep,2])
  res$vars <- mat[which(keep),]
  return(res)
}

en <- generateMasterEdgeNames(nGenes)
fullEdgeMatrix <- matrix(0,length(en),length(allNetworks)+3)
#rownames(fullEdgeMatrix) <- en$names

colnames(fullEdgeMatrix) <- c('id','var1','var2',methodNames)
fullEdgeMatrix <- data.frame(fullEdgeMatrix,stringsAsFactors = FALSE)
fullEdgeMatrix$id <- en$names
b <- synGet('syn4550165')
key <- read.csv(b@filePath,stringsAsFactors = FALSE)

fullEdgeMatrix$var1 <- key$geneName[en$vars[,1]]
fullEdgeMatrix$var2 <- key$geneName[en$vars[,2]]

variableNames <- lapply(allNetworks,function(x) return(paste0(x$var1,'_',x$var2)))
for (i in 1:length(allNetworks)){
  fullEdgeMatrix[variableNames[i],i+2] <- allNetworks[[i]]$value
  gc()
}

tcresult<-as.tableColumns(df)
cols<-tcresult$tableColumns
fileHandleId<-tcresult$fileHandleId
schema<-TableSchema(name=tableName, parent=projectId, columns=cols)
table<-Table(schema, fileHandleId)
table<-synStore(table, retrieveData=FALSE)

