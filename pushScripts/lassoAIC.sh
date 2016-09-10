aws s3 mv $outputpath/lassoAICNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/lassoAICNetwork.csv $outputpath/lassoAICtempmd5.out $parentId $annotationFile $provenanceFile $bucket "lassoAIC"
