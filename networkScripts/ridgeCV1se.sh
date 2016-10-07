#!/bin/bash
mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCV1se" $outputpath
Rscript $pathv/computeMD5.R $outputpath/ridgeCV1seNetwork.csv $outputpath/ridgetempmd5.out
