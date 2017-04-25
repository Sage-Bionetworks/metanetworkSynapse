###integration test script

library(synapseClient)
library(dplyr)
synapseLogin()

cfnClusterFolderId = 'syn7506046'
starClusterFolderId = 'syn7255211'

cfnFiles = paste0('select name,id from file where parentId==\'',
               cfnClusterFolderId,
               '\'') %>% synQuery

starFiles = paste0('select name,id from file where parentId==\'',
                   starClusterFolderId,
                   '\'') %>% synQuery

combinedTable = merge(cfnFiles,starFiles,by='file.name',stringsAsFactors=F)

populateMd5 = function(x){
  foo = synGet(x,downloadFile=F)
  return(foo@fileHandle$contentMd5)
}

combinedTable = dplyr::mutate(combinedTable,cfnMd5 = sapply(file.id.x,populateMd5),starMd5 = sapply(file.id.y,populateMd5))
combinedTable = dplyr::mutate(combinedTable, test = cfnMd5!=starMd5)
failedTable = dplyr::filter(combinedTable,test==TRUE)

foo1 <- synGet(failedTable$file.id.x[1])
foo2 <- synGet(failedTable$file.id.y[1])

load(foo1@filePath)
cfnbic <- bicNetworks
load(foo2@filePath)
starbic <- bicNetworks

cfnNet <- as.matrix(cfnbic$network)
starNet <- as.matrix(starbic$network)


bar1 <- read.csv(foo1@filePath,stringsAsFactors=F,row.names=1)
bar2 <- read.csv(foo2@filePath,stringsAsFactors=F,row.names=1)
bar4 = abs(bar1-bar2)


