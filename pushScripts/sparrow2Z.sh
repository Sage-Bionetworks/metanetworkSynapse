aws s3 mv $outputpath/sparrow2ZNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/sparrow2ZNetwork.csv $outputpath/sparrow2tempmd5.out $parentId $annotationFile $provenanceFile $bucket "sparrow2"
