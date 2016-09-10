aws s3 mv $outputpath/ridgeCV1seNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/ridgeCV1seNetwork.csv $outputpath/ridgeCV1setempmd5.out $parentId $annotationFile $provenanceFile $bucket "ridgeCV1se"
