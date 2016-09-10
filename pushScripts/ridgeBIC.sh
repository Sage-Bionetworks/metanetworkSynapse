aws s3 mv $outputpath/ridgeBICNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/ridgeBICNetwork.csv $outputpath/ridgeBICtempmd5.out $parentId $annotationFile $provenanceFile $bucket "ridgeBIC"
