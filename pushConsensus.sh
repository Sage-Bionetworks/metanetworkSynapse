#!/bin/bash

pathv=`dirname $0`

. $pathv/config.sh

if [ -e $outputpath/bicNetworks.rda ] && [ -e $outputpath/rankConsensusNetwork.csv ]; then
    python2.7 $pathv/pushToSynapse.py "$outputpath/bicNetworks.rda" "$parentId" "$outputpath/rankConsensusAnnoFile.txt" "$outputpath/rankConsensusProvenanceFile.txt" "bic" 
    python2.7 $pathv/pushToSynapse.py "$outputpath/rankConsensusNetwork.csv" "$parentId" "$outputpath/rankConsensusAnnoFile.txt" "$outputpath/rankConsensusProvenanceFile.txt" "rankConsensus" 
fi
