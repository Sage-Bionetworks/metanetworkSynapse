#!/bin/bash

#location of metanetwork synapse scripts
pathv=$( cd $(dirname $0) ; pwd -P )

. $pathv/config.sh

nets=( "aracne" "c3net" "genie3" "lassoAIC" "lassoBIC" "lassoCV1se" "lassoCVmin" "mrnet" "ridgeAIC" "ridgeBIC" "ridgeCV1se" "ridgeCVmin" "sparrowZ" "sparrow2Z" "tigress" "wgcnaSoftThreshold" "wgcnaTopologicalOverlapMatrix" )
branch=$( git rev-parse --abbrev-ref HEAD )

for net in ${nets[@]}; do
    if [ -e $outputpath/${net}Network.csv ]; then
        python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net $branch
    else
        echo "$outputpath/${net}Network.csv not found"
    fi
done
