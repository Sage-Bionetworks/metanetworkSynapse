fileName <- as.character(commandArgs(TRUE)[[1]])
outputpath <- as.character(commandArgs(TRUE)[[2]])
networkFolderId <- as.character(commandArgs(TRUE)[[3]])
provenanceFile <- as.character(commandArgs(TRUE)[[4]])

buildConsensus = function(fileName,outputpath,networkFolderId,provenanceFile){
  library(synapseClient)
  library(metanetwork)
  synapseLogin()

  #get all networks from Synapse
  foo <- synQuery(paste0('select name,id from file where parentId==\'',networkFolderId,'\''))
  bar <- lapply(foo$file.id,synGet,downloadLocation=outputpath)
  #print(foo)

  #update provenanceFile
  provenance <- read.csv(provenanceFile,stringsAsFactors=F)
  provenance <- as.matrix(provenance)
  provenance <- rbind(provenance,cbind(foo$file.id,rep(FALSE,nrow(foo))))
  write.csv(provenance,paste0(outputpath,'rankConsensusProvenanceFile.txt'),quote=F,row.names=F)
  #print(provenance)
  #load networks into R session

  loadNetwork <- function(file){
    library(data.table)
    sparrowNetwork <- data.table::fread(file,stringsAsFactors=FALSE,data.table=F)
    rownames(sparrowNetwork) <- sparrowNetwork$V1
    sparrowNetwork <- sparrowNetwork[,-1]
    gc()
    return(sparrowNetwork)
  }

  networkFiles <- sapply(bar,function(x){return(x@filePath)})
  networks <- lapply(networkFiles,loadNetwork)
  networks <- lapply(networks,data.matrix)

  #build rank consensus
  network <- metanetwork::rankConsensus(networks)

  write.csv(network,file=paste0(outputpath,'rankConsensusNetwork.csv'),quote=F)

}
buildConsensus(fileName,outputpath,networkFolderId,provenanceFile)
