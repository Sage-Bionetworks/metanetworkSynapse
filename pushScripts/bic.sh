aws s3 mv $outputpath/bicNetworks.rda $s3
provenanceFileUpdated=$outputpath/rankConsensusProvenanceFile.txt
Rscript $pathv/s3LinkToSynapse.R $s3b/bicNetworks.rda $outputpath/bicnetworkstempmd5.out $parentId $annotationFile $provenanceFileUpdated "bic"
