#!/bin/bash
Rscript $pathv/buildOtherNet.R $dataFile $pathv "c3netWrapper" "NULL" $outputpath
Rscript $pathv/computeMD5.R $outputpath/c3netNetwork.csv $outputpath/c3nettempmd5.out
