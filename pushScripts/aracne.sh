aws s3 mv $outputpath/aracneNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/aracneNetwork.csv $outputpath/aracnetempmd5.out $parentId $annotationFile $provenanceFile $bucket "aracne"
