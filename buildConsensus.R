fileName <- as.character(commandArgs(TRUE)[[1]])
outputpath <- as.character(commandArgs(TRUE)[[2]])
networkFolderId <- as.character(commandArgs(TRUE)[[3]])

buildConsensus = function(outputpath,networkFolderId, fileName){
  library(synapseClient)
  library(metanetwork)
  library(reader)
  synapseLogin()

  #get all networks from Synapse
  foo <- synQuery(paste0('select name,id from file where parentId==\'',networkFolderId,'\''))
  bar <- lapply(foo$file.id,synGet,downloadLocation=outputpath)

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

  networks$rankConsensus <- metanetwork::rankConsensus(networks)
  cat('built rank consensus\n')
  if(!is.null(fileName)){
    library(Matrix)
    networkMethods <- sapply(bar,synGetAnnotation,which='method')
    cat('grabbed methods\n')
    #build rank consensus
    cat('updated methods\n')
    networkMethods <- c(networkMethods,'rankConsensus')
    cat('reading in data\n')
    options(stringsAsFactors = F)
    dataSet <- reader(fileName, row.names=1)
    cat('turning data into data matrix\n')
    dataSet <- data.matrix(dataSet)
    cat('build bicNetworks\n')
    bicNetworks <- metanetwork::computeBICcurve(networks$rankConsensus,dataSet,maxEdges=1e5)
    cat('save bicNetworks\n')
    save(bicNetworks,file=paste0(outputpath,'bicNetworks.rda'))
  }
  cat('write rank consensus\n')
  write.csv(networks$rankConsensus,file=paste0(outputpath,'rankConsensusNetwork.csv'),quote=F)
}
buildConsensus(outputpath,networkFolderId,fileName)
