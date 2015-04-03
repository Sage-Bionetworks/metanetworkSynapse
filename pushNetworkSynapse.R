require(synapseClient)
synapseLogin()

#normalization method (if applicable)
#network inference method
#file with syn ids of data used to run network analysis
#file with code urls of code used to run network analysis
#syn id of project to post networks to
#tissue type of data used to build networks
#disease state
#organism
#what type of edge summary is present in file


file=as.character(commandArgs(TRUE)[[1]])
disease=as.character(commandArgs(TRUE)[[2]])
normalization=as.character(commandArgs(TRUE)[[3]])
method=as.character(commandArgs(TRUE)[[4]])
synIdFile <- as.character(commandArgs(TRUE)[[5]])
synCodeUrlFile <- as.character(commandArgs(TRUE)[[6]])

#load('result.rda')
#write.csv(result,file=file,quote=F)
parentId <- 'syn3455061'
synNet <- File(file,parentId=parentId)

networkAnnotation <- list(
  tissueType = 'Dorsolateral Prefrontal Cortex',
  disease = disease,
  normalization = normalization,
  method = method,
  fileType = 'csv',
  organism = 'Homo sapiens',
  dataType = 'metaData'
)

synSetAnnotations(synNet) <- networkAnnotation

act <- Activity(name = paste0(method,' ',disease,' network analysis'),
                used = list(list(entity=synGene,wasExecuted=FALSE),list(entity=synTF,wasExecuted=FALSE),list(entity=synMeta,wasExecuted=FALSE)),
                executed=list("https://github.com/blogsdon/CMCSPARROW/blob/master/grabCMCdata.sh","https://github.com/blogsdon/CMCSPARROW/blob/master/runcmcsparrow.sh"))

act <- storeEntity(act)
generatedBy(synNet) <- act
synNet <- synStore(synNet)
