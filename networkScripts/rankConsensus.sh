#!/bin/sh
Rscript $pathv/buildConsensus.R $dataFile $outputpath $networkFolderId
Rscript $pathv/computeMD5.R $outputpath/rankConsensusNetwork.csv $outputpath/rankconsensustempmd5.out
Rscript $pathv/computeMD5.R $outputpath/bicNetworks.rda $outputpath/bicnetworkstempmd5.out
