mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeAIC" $outputpath
Rscript $pathv/computeMD5.R $outputpath/ridgeAICNetwork.csv $outputpath/ridgeAICtempmd5.out
