#login to Synapse

require(synapseClient)
synapseLogin()

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

#write to csv
file <- paste0(method,'_',disease,'_',normalization,'.csv')
write.csv(network,file=file,quote=F)

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

#define provenance: FIX FIX FIX
act <- Activity(name = paste0(method,' ',disease,' network analysis'),
                used = list(list(entity=synGene,wasExecuted=FALSE),list(entity=synTF,wasExecuted=FALSE),list(entity=synMeta,wasExecuted=FALSE)),
                executed=list("https://github.com/blogsdon/CMCSPARROW/blob/master/grabCMCdata.sh","https://github.com/blogsdon/CMCSPARROW/blob/master/runcmcsparrow.sh"))

act <- storeEntity(act)
generatedBy(synNet) <- act

#store in Synapse
synNet <- synStore(synNet)
