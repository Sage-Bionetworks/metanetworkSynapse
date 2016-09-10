mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $numberCore $pathv "sparrowZ" $outputpath
Rscript $pathv/computeMD5.R $outputpath/sparrowZNetwork.csv $outputpath/sparrowtempmd5.out
