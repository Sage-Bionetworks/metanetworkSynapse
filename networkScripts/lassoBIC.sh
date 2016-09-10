mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $numberCore $pathv "lassoBIC" $outputpath
Rscript $pathv/computeMD5.R $outputpath/lassoBICNetwork.csv $outputpath/lassoBICtempmd5.out
