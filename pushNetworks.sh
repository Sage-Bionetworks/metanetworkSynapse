#!/bin/bash

token=$1

pathv=$( cd $(dirname $0) ; pwd -P )/

nets=( "aracne" "c3net" "genie3" "lassoAIC" "lassoBIC" "lassoCV1se" "lassoCVmin" "mrnet" "ridgeAIC" "ridgeBIC" "ridgeCV1se" "ridgeCVmin" "sparrowZ" "sparrow2Z" "tigress" "wgcnaSoftThreshold" "wgcnaTopologicalOverlapMatrix" )
branch=$( git rev-parse --abbrev-ref HEAD )

. $pathv/config.sh

for net in ${nets[@]}; do
    if [ -e $outputpath/${net}Network.csv ]; then
        python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net $branch $token
    else
        echo "$outputpath/${net}Network.csv not found"
    fi
done
