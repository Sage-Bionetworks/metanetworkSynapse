aws s3 mv $outputpath/sparrowZNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/sparrowZNetwork.csv $outputpath/sparrowtempmd5.out $parentId $annotationFile $provenanceFile $bucket "sparrow"
