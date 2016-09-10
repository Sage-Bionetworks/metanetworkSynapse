mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $numberCore $pathv "ridgeAIC" $outputpath
Rscript $pathv/computeMD5.R $outputpath/ridgeAICNetwork.csv $outputpath/ridgeAICtempmd5.out
