aws s3 mv $outputpath/lassoCV1seNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/lassoCV1seNetwork.csv $outputpath/lassoCV1setempmd5.out $parentId $annotationFile $provenanceFile $bucket "lassoCV1se"
