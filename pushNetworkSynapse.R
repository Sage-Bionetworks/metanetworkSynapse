require(synapseClient)
synapseLogin()

file=as.character(commandArgs(TRUE)[[1]])
disease=as.character(commandArgs(TRUE)[[2]])
normalization=as.character(commandArgs(TRUE)[[3]])
method=as.character(commandArgs(TRUE)[[4]])
synGene=as.character(commandArgs(TRUE)[[5]])
synTF=as.character(commandArgs(TRUE)[[6]])
synMeta=as.character(commandArgs(TRUE)[[7]])

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
