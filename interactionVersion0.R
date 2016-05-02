generateStatistics <- function(networkId,backgroundId,storageLocation,method,provenanceURL){
  networkObj <- synGet(networkId,downloadLocation = './')
  backgroundObj <- synGet(as.character(backgroundId))
  
  #network <- loadNetwork(networkObj@filePath)
  load(networkObj@filePath)
  load(backgroundObj@filePath)
  #library(ROCR)

  referenceSet <- which(net2!=0)
  diag(net2) <- 0
  gc()
  net2[which(lower.tri(net2))] <- 0
  
  getEdge = function(x){
    return(which(x$network!=0))
  }
  
  testSets <- lapply(bicNetworks,getEdge)
  
  makeTables <- function(x,y,n){
    table1 <- matrix(0,2,2)
    table1[2,2] <- length(intersect(x,y))
    table1[1,2] <- length(x)-table1[2,2]
    table1[2,1] <- length(y)-table1[2,2]
    table1[1,1] <- n - sum(table1)
    return(table1)
  }
  #makeTables(referenceSet,testSets[[1]],choose(ncol(net2),2))
  allTables<-sapply(testSets,makeTables,referenceSet,choose(ncol(net2),2))
  rownames(allTables) <- c('TN','FN','FP','TP')
  allTables <- t(allTables)
  allTables <- data.frame(allTables,stringsAsFactors = F)
  
  n1 <- rownames(allTables)
  allTables$method <- n1
  
  allTables <- dplyr::mutate(allTables,
                TPR = TP/(TP+FN),
                SPC = TN/(TN+FP),
                PPV = TP/(TP+FP),
                NPV = TN/(TN+FN),
                FPR = FP/(FP+TN),
                FNR = FN/(TP+FN),
                FDR = FP/(TP+FP),
                ACC = (TP+TN)/(TP+FP+FN+TN),
                F1 = 2*TP/(2*TP+FP+FN),
                MCC = (TP*TN - FP*FN)/(sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN))))
  
  #allTables$Precision <- allTables$TP/(allTables$TP + allTables$FP)
  #allTables$TPR <- 

  #save(predictionObj,file=paste0(method,'BiogridPrediction.rda'))
  write.csv(allTables,file='BiogridPrediction.csv',quote=F,row.names=F)
  foobar<-File(paste0(method,'BiogridPrediction.csv'),parentId=storageLocation)
  #foo <- synStore(foo,used=used,executed=executed,activityName=activityName,forceVersion=F)
  synSetAnnotations(foobar) <- list(fileType='csv',
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


foo <- synQuery('select name,id,study,tissueTypeAbrv,disease,cogdx,fileType,method from file where projectId==\'syn5584871\' and analysisType==\'statisticalNetworkReconstruction\'')

library(dplyr)
foo2 <- filter(foo,!is.na(file.tissueTypeAbrv) & !is.na(file.study))
interactionReference<- mapply(whichInteractionMatrix,foo2$file.tissueTypeAbrv,foo2$file.study,SIMPLIFY = TRUE)
foo2 <- cbind(foo2,interactionReference)

#foo2 <- filter(foo2,file.fileType=='csv' & !is.na(interactionReference))
foo2 <- filter(foo2,file.fileType=='rda' & !is.na(interactionReference))
View(foo2)

foo2$resultLocation <- sapply(foo2$file.id,rSynapseUtilities::getGrandParent)
foo2$interactionReference <- as.character(foo2$interactionReference)

generateStatistics <- function(networkId,backgroundId,storageLocation,method,provenanceURL)
mapply(generateStatistics,networkId=foo2$file.id[1:2],backgroundId=foo2$interactionReference[1:2],storageLocation=foo2$resultLocation[1:2],method=foo2$file.method[1:2],provenanceURL='https://github.com/blogsdon/metanetworkSynapse/blob/1cba157afbea53a98b007ebf10d584464421fbcb/interactionVersion0.R')

