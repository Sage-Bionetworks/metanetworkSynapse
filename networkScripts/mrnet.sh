Rscript $pathv/buildOtherNet.R $dataFile $pathv "mrnetWrapper" "NULL" $outputpath
Rscript $pathv/computeMD5.R $outputpath/mrnetNetwork.csv $outputpath/mrnettempmd5.out
Rscript $pathv/computeMD5.R $outputpath/aracneNetwork.csv $outputpath/aracnetempmd5.out
