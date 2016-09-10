aws s3 mv $outputpath/ridgeAICNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/ridgeAICNetwork.csv $outputpath/ridgeAICtempmd5.out $parentId $annotationFile $provenanceFile $bucket "ridgeAIC"
