mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $numberCore $pathv "lassoCV1se" $outputpath
Rscript $pathv/computeMD5.R $outputpath/lassoCV1seNetwork.csv $outputpath/lassoCV1setempmd5.out
