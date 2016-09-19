#!/bin/bash

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

nets=( "aracne" "c3net" "genie3" "lassoAIC" "lassoBIC" "lassoCV1se" "mrnet" "ridgeAIC" "ridgeBIC" "ridgeCV1se" "ridgeCVmin" "sparrowZ" "sparrow2Z" "tigress" "wgcnaSoftThreshold" "wgcnaTopologicalOverlapMatrix" )

for net in ${nets[@]}; do
    if [ -e $outputpath/${net}Network.csv ]; then
        python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
    else
        echo "$outputpath/${net}Network.csv not found"
    fi
done

if [ -e $outputpath/bicNetworks.rda ] && [ -e $outputpath/rankConsensusNetwork.csv ]; then
    python2.7 $pathv/pushToSynapse.py "$outputpath/bicNetworks.rda" "$parentId" "$outputpath/buildConsensusAnnoFile.txt" "$outputpath/rankConsensusProvenanceFile.txt" "bic" 
    python2.7 $pathv/pushToSynapse.py "$outputpath/rankConsensusNetwork.csv" "$parentId" "$outputpath/buildConsensusAnnoFile.txt" "$outputpath/rankConsensusProvenanceFile.txt" "rankConsensus" 
fi

