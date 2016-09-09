Rscript $pathv/buildOtherNet.R $dataFile $pathv "wgcnaTOM" "NULL" $outputpath
Rscript $pathv/computeMD5.R $outputpath/wgcnaTopologicalOverlapMatrixNetwork.csv $outputpath/wgcnaTOMtempmd5.out
Rscript $pathv/computeMD5.R $outputpath/wgcnaSoftThresholdNetwork.csv $outputpath/wgcnaSoftThresholdtempmd5.out
