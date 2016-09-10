mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $numberCore $pathv "lassoCVmin" $outputpath
Rscript $pathv/computeMD5.R $outputpath/lassoCVminNetwork.csv $outputpath/lassoCVmintempmd5.out
