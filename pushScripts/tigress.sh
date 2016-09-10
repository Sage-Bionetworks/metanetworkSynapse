aws s3 mv $outputpath/tigressNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/tigressNetwork.csv $outputpath/tigresstempmd5.out $parentId $annotationFile $provenanceFile $bucket "tigress"
