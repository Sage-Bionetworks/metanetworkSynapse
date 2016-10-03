#!/bin/bash

#location of metanetwork synapse scripts
pathv=$( cd $(dirname $0) ; pwd -P )

. $pathv/config.sh

if [ -e $outputpath/bicNetworks.rda ] && [ -e $outputpath/rankConsensusNetwork.csv ]; then
    python2.7 $pathv/pushToSynapse.py "$outputpath/bicNetworks.rda" "$parentId" "$outputpath/rankConsensusAnnoFile.txt" "$outputpath/rankConsensusProvenanceFile.txt" "bic" 
    python2.7 $pathv/pushToSynapse.py "$outputpath/rankConsensusNetwork.csv" "$parentId" "$outputpath/rankConsensusAnnoFile.txt" "$outputpath/rankConsensusProvenanceFile.txt" "rankConsensus" 
fi
