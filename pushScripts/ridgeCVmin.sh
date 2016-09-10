aws s3 mv $outputpath/ridgeCVminNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/ridgeCVminNetwork.csv $outputpath/ridgeCVmintempmd5.out $parentId $annotationFile $provenanceFile $bucket "ridgeCVmin"
