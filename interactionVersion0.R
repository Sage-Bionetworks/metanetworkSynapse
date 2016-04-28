generateStatistics <- function(networkId,backgroundId,storageLocation,method,provenanceURL){
  networkObj <- synGet(networkId,downloadLocation = './')
  backgroundObj <- synGet(backgroundId)
  
  loadNetwork <- function(file){
    library(data.table)
    sparrowNetwork <- data.table::fread(file,stringsAsFactors=FALSE,data.table=F)
    rownames(sparrowNetwork) <- sparrowNetwork$V1
    sparrowNetwork <- sparrowNetwork[,-1]
    gc()
    return(sparrowNetwork)
  }
  
  network <- loadNetwork(networkObj@filePath)
  load(backgroundObj@filePath)
  library(ROCR)
  
  upperTriangular = which(upper.tri(network))
  predvec <- as.matrix(network)[upperTriangular]
  truevec <- as.matrix(net2)[upperTriangular]
  predictionObj <- prediction(predvec,truevec)
  #return(predictionObj)
  save(predictionObj,file=paste0(method,'BiogridPrediction.rda'))
  foobar<-File(paste0(method,'BiogridPrediction.rda'),parentId=storageLocation)
  #foo <- synStore(foo,used=used,executed=executed,activityName=activityName,forceVersion=F)
  synSetAnnotations(foobar) <- list(fileType='rda',
                                    dataType='analysis',
                                    analysisType='interactionNetworkPrediction',
                                    interactionNetworkType='PPI',
                                    interactionNetworkSubType='biogrid',
                                    statisticalNetworkReconstructionMethod=method)
  foobar<-synStore(foobar,used=list(network=networkId,biogridNetwork=backgroundId),executed=as.list(provenanceURL),activityName='Interaction Prediction')
  system(paste0('rm ',networkObj@filePath))
  gc()
}

whichInteractionMatrix = function(file.tissueTypeAbrv,file.study){
  if(file.tissueTypeAbrv=='DLPFC' & file.study=='CMC'){
    return('syn5996138')
  }else if(file.tissueTypeAbrv=='ACC' & file.study=='CMC'){
    return('syn5996140')
  }else if(file.tissueTypeAbrv=='DLPFC' & file.study=='HBCC'){
    return('syn5996133')
  }else if(file.tissueTypeAbrv=='DLPFC' & file.study=='ROSMAP'){
    return('syn5996136')
  }else{
    return(NA)
  }
}

require(synapseClient)
synapseLogin()


foo <- synQuery('select name,id,study,tissueTypeAbrv,disease,cogdx,fileType from file where projectId==\'syn5584871\' and analysisType==\'statisticalNetworkReconstruction\'')

library(dplyr)
foo2 <- filter(foo,!is.na(file.tissueTypeAbrv) & !is.na(file.study))
interactionReference<- mapply(whichInteractionMatrix,foo2$file.tissueTypeAbrv,foo2$file.study,SIMPLIFY = TRUE)
foo2 <- cbind(foo2,interactionReference)

foo2 <- filter(foo2,file.fileType=='csv' & !is.na(interactionReference))
View(foo2)

foo2$resultLocation <- sapply(foo2$file.id,rSynapseUtilities::getGrandParent)

mapply(generateStatistics,)

