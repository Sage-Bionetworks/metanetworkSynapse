#!/bin/bash
mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "tigress" $outputpath
Rscript $pathv/computeMD5.R $outputpath/tigressNetwork.csv $outputpath/tigresstempmd5.out
