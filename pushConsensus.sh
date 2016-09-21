#!/bin/bash

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh
if [ -e $outputpath/bicNetworks.rda ] && [ -e $outputpath/rankConsensusNetwork.csv ]; then
    python2.7 $pathv/pushToSynapse.py "$outputpath/bicNetworks.rda" "$parentId" "$outputpath/buildConsensusAnnoFile.txt" "$outputpath/rankConsensusProvenanceFile.txt" "bic" 
    python2.7 $pathv/pushToSynapse.py "$outputpath/rankConsensusNetwork.csv" "$parentId" "$outputpath/buildConsensusAnnoFile.txt" "$outputpath/rankConsensusProvenanceFile.txt" "rankConsensus" 
fi
