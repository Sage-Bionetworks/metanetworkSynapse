aws s3 mv $outputpath/c3netNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/c3netNetwork.csv $outputpath/c3nettempmd5.out $parentId $annotationFile $provenanceFile $bucket "c3net"
