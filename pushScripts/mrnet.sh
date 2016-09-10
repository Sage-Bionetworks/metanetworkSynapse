aws s3 mv $outputpath/mrnetNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/mrnetNetwork.csv $outputpath/mrnettempmd5.out $parentId $annotationFile $provenanceFile $bucket "mrnet"

