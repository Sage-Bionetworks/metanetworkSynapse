aws s3 mv $outputpath/wgcnaTopologicalOverlapMatrixNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/wgcnaTopologicalOverlapMatrixNetwork.csv $outputpath/wgcnaTOMtempmd5.out $parentId $annotationFile $provenanceFile $bucket "wgcnaTopologicalOverlapMatrix"

aws s3 mv $outputpath/wgcnaSoftThresholdNetwork.csv $s3
Rscript $pathv/s3LinkToSynapse.R $s3b/wgcnaSoftThresholdNetwork.csv $outputpath/wgcnaSoftThresholdtempmd5.out $parentId $annotationFile $provenanceFile $bucket "wgcnaSoftThreshold"
