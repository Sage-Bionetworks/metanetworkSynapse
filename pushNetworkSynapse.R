#login to Synapse

require(synapseClient)
synapseLogin()
require(metaNet)

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
network <- network %>% symmetrisize



if (method=='genie3'|method=='ridge'){
  network <- applyScaleFree(network);
} else if (method=='sparrow'){
  network <- applySparrowBonferroni(network);
} else if (method=='aracne'|method=='lasso'|method=='tigress'){
  network <- network!=0;
}
diag(network) <- 0
network <- apply(network,2,as.integer)
rownames(network) <- colnames(network)


#write to csv
file <- paste0(method,'_',disease,'_',normalization,'.csv')
write.csv(network,file=file,quote=F)
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
  dataType = 'metaData',
  edgeType = edgeType
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
