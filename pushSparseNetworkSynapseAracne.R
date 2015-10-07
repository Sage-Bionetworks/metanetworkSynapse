#login to Synapse

require(synapseClient)
synapseLogin()
require(metanetwork)
require(dplyr)

#syn id of project to post networks to
#file with syn ids of data used to run network analysis
#file with code urls of code used to run network analysis
#network inference method
#normalization method (if applicable)
#tissue type of data used to build networks
#disease state
#organism
#what type of edge summary is present in file

parentId <- as.character(commandArgs(TRUE)[[1]])
synIdFile <- as.character(commandArgs(TRUE)[[2]])
synCodeUrlFile <- as.character(commandArgs(TRUE)[[3]])
method <- as.character(commandArgs(TRUE)[[4]])
normalization <- as.character(commandArgs(TRUE)[[5]])
tissueType <- as.character(commandArgs(TRUE)[[6]])
disease <- as.character(commandArgs(TRUE)[[7]])
organism <- as.character(commandArgs(TRUE)[[8]])
edgeType <- as.character(commandArgs(TRUE)[[9]])
spar <- data.frame((read.csv('sparsity.csv',header=F,row.names=1)))

if(method=='sparrow1'){
  load('result_sparrowZ.rda')
} else if (method=='sparrow2'){
  load('result_sparrow2Z.rda')
}else if (method=='aracne'){
  load('result_aracneFull.rda')
}else if (method=='correlation'){
  load('result_correlation.rda')
}else if (method=='lassoCV1se'){
  load('result_lassoCV1se.rda')
}else if (method=='lassoCVmin'){
  load('result_lassoCVmin.rda')
}else if (method=='lassoAIC'){
  load('result_lassoAIC.rda')
}else if (method=='lassoBIC'){
  load('result_lassoBIC.rda')
}else if (method=='ridgeCV1se'){
  load('result_ridgeCV1se.rda')
}else if (method=='ridgeCVmin'){
  load('result_ridgeCVmin.rda')
}else if (method=='ridgeBIC'){
  load('result_ridgeBIC.rda')
}else if (method=='ridgeAIC'){
  load('result_ridgeAIC.rda')
}else if (method=='tigress'){
  load('result_tigress.rda')
}else if (method=='genie3'){
  load('result_genie3.rda')
}

library(Matrix)
cat('changing to matrix\n')
network  <- network %>% as.matrix
diag(network) <- 0
cat('symmetrisizing\n')
network <- network %>% symmetrisize
nEdgesScaleFreeNetwork <- NA
if(!is.na(nEdgesScaleFreeNetwork)){
  cat(paste0(method,'ScaleFree,',nEdgesScaleFreeNetwork,'\n'),append = T,file = 'sparsity.csv')
}
cat('apply ranked edge list\n')

anno <- list(
  tissueType = tissueType,
  disease = disease,
  normalization = normalization,
  method = method,
  fileType = 'rda',
  organism = organism,
  dataType = 'metaData'
)

#make folder
synFolder <- Folder(name=paste0(anno$method,'Sparse'),parentId=parentId)
synFolder <- synStore(synFolder)
foldId <- synGetProperties(synFolder)$id

makeSparse <- function(x){
  require(Matrix)
  return(Matrix(x,sparse=TRUE))
}


wkeep <- which(rownames(spar)=='aracne')
nets <- lapply(spar$V2[wkeep],arbitrarySparsity,network)
gc()
dropNA <- which(!is.na(nets))
#if(length(dropNA)>0){
nets <- nets[dropNA]
#}
nets <- lapply(nets,makeSparse)
gc()



for(i in 1:length(nets)){
  sparsityMethod <- rownames(spar)[dropNA][i]
  fileName <- paste0(anno$method,sparsityMethod,'.rda')
  sparseNetwork <- nets[[i]]
  save(sparseNetwork,file=fileName)
  synObj <- File(fileName,parentId=foldId)
  anno$sparsityMethod <- sparsityMethod
  anno$networkStorageType <- 'sparse'
  synSetAnnotations(synObj) <- anno
  #act <- Activity(name='sparsify networks',used=as.list(c(sparsitySyn,networkSyn,geneSyn)),executed=as.list(executed))
  #act <- storeEntity(act)
  usedEntity <- readLines(synIdFile);
  codeUrl <- readLines(synCodeUrlFile);
  act <- Activity(name = paste0(method,' ',disease,' network analysis'),
                  used = as.list(usedEntity),
                  executed=as.list(codeUrl))
  
  act <- storeEntity(act)  
  generatedBy(synObj) <- act
  synObj <- synStore(synObj)  
}

