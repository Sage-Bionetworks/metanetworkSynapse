mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoAIC" $outputpath
Rscript $pathv/computeMD5.R $outputpath/lassoAICNetwork.csv $outputpath/lassoAICtempmd5.out
