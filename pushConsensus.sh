#!/bin/bash

#location of metanetwork synapse scripts
pathv=$( cd $(dirname $0) ; pwd -P )

. $pathv/config.sh
branch=$( git rev-parse --abbrev-ref HEAD )

if [ -e $outputpath/bicNetworks.rda ] && [ -e $outputpath/rankConsensusNetwork.csv ]; then
    python2.7 $pathv/pushToSynapse.py "$outputpath/bicNetworks.rda" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" "bic" $branch
    python2.7 $pathv/pushToSynapse.py "$outputpath/rankConsensusNetwork.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" "rankConsensus" $branch 
fi
