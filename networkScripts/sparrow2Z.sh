#!/bin/bash
mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrow2Z" $outputpath
Rscript $pathv/computeMD5.R $outputpath/sparrow2ZNetwork.csv $outputpath/sparrow2tempmd5.out
