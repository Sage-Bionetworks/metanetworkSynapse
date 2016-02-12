s3file <- as.character(commandArgs(TRUE)[[1]])
md5location <- as.character(commandArgs(TRUE)[[2]])
parentId <- as.character(commandArgs(TRUE)[[3]])
annotationFile <- as.character(commandArgs(TRUE)[[4]])
provenanceFile <- as.character(commandArgs(TRUE)[[5]])
method <- as.character(commandArgs(TRUE)[[6]])
s3LinkToSynapse <- function(s3file,md5location,parentId,annotationFile,provenanceFile,method,activityName='Network Inference',AWSbucketName='metanetworks'){
    require(synapseClient)
    synapseLogin()
    md5 <- readLines(md5location)
    getFileName <- function(x){
      foo <- strsplit(x,'/')[[1]]
      nl <- length(foo)
      return(foo[nl])
    }
    
    fileName <- getFileName(s3file)
    
    storageLocation <- synRestPOST("/storageLocation", list(
      concreteType="org.sagebionetworks.repo.model.project.ExternalS3StorageLocationSetting",
      uploadType="S3",
      bucket=AWSbucketName,
      baseKey=""))    
    
    s3filehandle <- synRestPOST("/externalFileHandle/s3", list(
      concreteType="org.sagebionetworks.repo.model.file.S3FileHandle",
      bucketName=AWSbucketName,
      key=s3file,
      fileName=fileName,
      contentType="application/octet-stream",
      contentMd5=md5,
      storageLocationId=storageLocation$storageLocationId ),endpoint=synapseFileServiceEndpoint())
    
    s3fileEntity = synRestPOST("/entity", list(
      concreteType="org.sagebionetworks.repo.model.FileEntity",
      name=fileName,
      dataFileHandleId=s3filehandle$id,
      parentId=parentId))
    
    foo <- synGet(s3fileEntity$id,downloadFile=F)
    annos <- read.csv(annotationFile,header=F,stringsAsFactors=F,row.names=1)
    annos <- as.list(data.frame(t(annos),stringsAsFactors=F))
    annos$method <- method
    synSetAnnotations(foo) <- annos
    provenance <- read.csv(provenanceFile,header=T,stringsAsFactors=F)
    used <- as.list(provenance$provenance[which(provenance$executed==FALSE)])
    executed <- as.list(provenance$provenance[which(provenance$executed==TRUE)])
    foo <- synStore(foo,used=used,executed=executed,activityName=activityName,forceVersion=F)
}
s3LinkToSynapse(s3file,md5location,parentId,annotationFile,provenanceFile,method)