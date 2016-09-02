#!/bin/sh

Rscript $pathv/buildConsensus.R $dataFile $outputpath $networkFolderId $provenanceFile
#compute md5

Rscript $pathv/computeMD5.R $outputpath/rankConsensusNetwork.csv $outputpath/rankconsensustempmd5.out
#push to s3

Rscript $pathv/computeMD5.R $outputpath/bicNetworks.rda $outputpath/bicnetworkstempmd5.out
