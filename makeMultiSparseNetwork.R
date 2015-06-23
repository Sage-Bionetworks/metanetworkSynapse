makeMultiSparseNetwork <- function(sparsitySyn,networkSyn,geneSyn,uploadFolder){
  require(synapseClient)
  synapseLogin()
  library(Matrix)
  sparObj <- synGet(sparsitySyn)
  networkSyn <- synGet(networkSyn)
  geneSyn <- synGet(geneSyn)
  
  spar <- read.csv(sparObj@filePath,stringsAsFactors=F,row.names=1)
  network <- read.csv(networkSyn@filePath,stringsAsFactors=F,row.names=1)
  gene <- read.csv(geneSyn@filePath,stringsAsFactors=F,row.names=1)
  
  edgeListToMatrix <- function(spar,edgeList,geneName,nNodes){
    network2 <- matrix(0,nNodes,nNodes)
    internal <- function(x,y,n){
      return((y-1)*n+x)
    }
    avec <- internal(edgeList[1:spar,1],edgeList[1:spar,2],nNodes)    
    network2[avec] <- as.numeric(edgeList[1:spar,3])
    network <- network+t(network)
    colnames(network2) <- geneName
    rownames(network2) <- geneName
    network <- Matrix(network2,sparse=TRUE)
    gc()
    return(network)
  }
  nNodes <- nrow(gene)
  
  allNetworks<-sapply(spar$V2[spar$V2<nrow(network)],edgeListToMatrix,network,rownames(gene),nNodes)
  
  anno <- as.list(synGetAnnotations(networkSyn))
  
  #make Folder
  synFolder <- Folder(name=paste0(anno$method,'Sparse'),parentId=uploadFolder)
  synFolder <- synStore(synFolder)
  foldId <- synGetProperties(synFolder)$id
  
  for (i in 1:length(allNetworks)){
    sparsityMethod <- rownames(spar)[spar$V2<nrow(network)][i]
    fileName <- paste0(anno$method,sparsityMethod,'.rda')
    sparseNetwork <- allNetworks[[i]]
    save(sparseNetwork,file=fileName)
    synObj <- File(fileName,parentId=foldId)
    anno$sparsityMethod <- sparsityMethod
    anno$networkStorageType <- 'sparse'
    synSetAnnotations(synObj) <- anno
    act <- Activity(name='sparsify networks',used=as.list(c(sparsitySyn,networkSyn,geneSyn)),executed=as.list(c('')))
    
    synObj <- synStore(synObj)
  }
  
}