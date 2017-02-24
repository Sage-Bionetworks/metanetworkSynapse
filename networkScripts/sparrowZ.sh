#!/bin/bash
mpiexec -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowZ" $outputpath
Rscript $pathv/computeMD5.R $outputpath/sparrowZNetwork.csv $outputpath/sparrowtempmd5.out
