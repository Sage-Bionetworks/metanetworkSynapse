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
load(paste0('result_',method,'.rda'))


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
