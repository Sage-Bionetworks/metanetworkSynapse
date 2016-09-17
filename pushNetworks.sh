#!/bin/bash

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

net="aracne"
if [ -e $outputpath/aracneNetwork.csv ]; then
    python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="c3net"
if [ -e $outputpath/c3netNetwork.csv ]; then
    python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="genie3"
if [ -e $outputpath/genie3Network.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="lassoAIC"
if [ -e $outputpath/lassoAICNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="lassoBIC"
if [ -e $outputpath/lassoBICNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="lassoCV1se"
if [ -e $outputpath/lassoCV1seNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="mrnet"
if [ -e $outputpath/mrnetNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="ridgeAIC"
if [ -e $outputpath/ridgeAICNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="ridgeBIC"
if [ -e $outputpath/ridgeBICNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="ridgeCV1se"
if [ -e $outputpath/ridgeCV1seNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="ridgeCVmin"
if [ -e $outputpath/ridgeCVminNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="sparrowZ"
if [ -e $outputpath/sparrowZNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="sparrow2Z"
if [ -e $outputpath/sparrow2ZNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="tigress"
if [ -e $outputpath/tigressNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi.csv

net="wgcnaSoftThreshold"
if [ -e $outputpath/wgcnaSoftThresholdNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

net="wgcnaTopologicalOverlapMatrix".csv
if [ -e $outputpath/wgcnaTopologicalOverlapMatrixNetwork.csv ]; then
     python2.7 $pathv/pushToSynapse.py "$outputpath/${net}Network.csv" "$parentId" "$outputpath/annoFile.txt" "$outputpath/provenanceFile.txt" $net 
else
    echo "$outputpath/${net}Network.csv not found"
fi

