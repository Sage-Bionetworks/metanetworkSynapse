aws s3 mv $outputpath/lassoBICNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/lassoBICNetwork.csv $outputpath/lassoBICtempmd5.out $parentId $annotationFile $provenanceFile $bucket "lassoBIC"
