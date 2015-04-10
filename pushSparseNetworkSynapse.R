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
require(Matrix)
file <- paste0(method,'_',disease,'_',normalization,'.csv')
fileS <- paste0(method,'_',disease,'_',normalization,'.rda')
network <- data.matrix(read.csv(file=file,row.names=1))
network <- Matrix(network,sparse=TRUE)


#save file
save(network,file=fileS)
#Sys.sleep(5)

#make synapse object
synNet <- File(fileS,parentId=parentId)

#definte annotation
networkAnnotation <- list(
  tissueType = tissueType,
  disease = disease,
  normalization = normalization,
  method = method,
  fileType = 'rda',
  organism = organism,
  dataType = 'metaData',
  edgeType = edgeType,
  matrixType = 'sparse'
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
