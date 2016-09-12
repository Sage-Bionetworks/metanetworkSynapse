mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCVmin" $outputpath
Rscript $pathv/computeMD5.R $outputpath/ridgeCVminNetwork.csv $outputpath/ridgeCVmintempmd5.out
