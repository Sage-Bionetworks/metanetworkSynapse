#!/bin/bash
mpiexec -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeBIC" $outputpath
Rscript $pathv/computeMD5.R $outputpath/ridgeBICNetwork.csv $outputpath/ridgeBICtempmd5.out
