#login to Synapse

require(synapseClient)
synapseLogin()
require(metaNet)
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


#load data
#load(paste0('result_',method,'.rda'))

#load sparsities
sparsity <- data.frame(t(read.csv('sparsity.csv',header=F,row.names=1)))

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

#enumurate methods

#sparsity <- read.csv('sparsity.csv',stringsAsFactors=F,row.names=1,header=F)
#colnames(network) <- rownames(network)
file <- paste0(method,'_',disease,'_',normalization,'.csv')

if(method!='sparsity'){
  cat('changing to matrix\n')
  network  <- network %>% as.matrix
  diag(network) <- 0
  cat('symmetrisizing\n')
  network <- network %>% symmetrisize
  #multiNetwork <- sparsity %>% lapply(arbitrarySparsity,network)
  #multiNetwork$scaleFreeNetwork <- applyScaleFree(network)
  nEdgesScaleFreeNetwork <- NA
  #cat('make scale free\n')
  #try(nEdgesScaleFreeNetwork <- applyScaleFree(network),silent=T)
  if(!is.na(nEdgesScaleFreeNetwork)){
    cat(paste0(method,'ScaleFree,',nEdgesScaleFreeNetwork,'\n'),append = T,file = 'sparsity.csv')
  }
  cat('apply ranked edge list\n')
  edgeList <- rankedEdgeList(network,symmetric = TRUE)
  
  #write to csv
}else{
  edgeList <- t(sparsity)
}
write.csv(edgeList,file=file,quote=F)
#save(multiNetwork,file=file,quote=F)
#Sys.sleep(5)

#make synapse object
synNet <- File(file,parentId=parentId)

#definte annotation
networkAnnotation <- list(
  tissueType = tissueType,
  disease = disease,
  normalization = normalization,
  method = method,
  fileType = 'csv',
  organism = organism,
  dataType = 'metaData'
)

#set annotations
synSetAnnotations(synNet) <- networkAnnotation

#define provenance
usedEntity <- readLines(synIdFile);
codeUrl <- readLines(synCodeUrlFile);

act <- Activity(name = paste0(method,' ',disease,' network analysis'),
                used = as.list(usedEntity),
                executed=as.list(codeUrl))

act <- storeEntity(act)
generatedBy(synNet) <- act

#store in Synapse
synNet <- synStore(synNet)
