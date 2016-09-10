aws s3 mv $outputpath/lassoCVminNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/lassoCVminNetwork.csv $outputpath/lassoCVmintempmd5.out $parentId $annotationFile $provenanceFile $bucket "lassoCVmin"
