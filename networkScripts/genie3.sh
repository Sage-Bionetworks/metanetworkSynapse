#!/bin/bash
mpiexec -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "genie3" $outputpath
Rscript $pathv/computeMD5.R $outputpath/genie3Network.csv $outputpath/genie3tempmd5.out
