#!/bin/bash

###bash script to push networks to Synapse after running buildNet.sh
###Author: Benjamin A Logsdon, 2015


sparrow=0
aracne=0
wgcna=0
lasso=0
ridge=0
genie3=0
tigress=0
sva=0

while getopts ":p:c:g:sawlrgtv" opt; do
  case $opt in
    p)
      projectId=$OPTARG
      ;;
    c)
      codeUrlFile=$OPTARG
      ;;
    g)
      synapseIdFile=$OPTARG
      ;;
    s)
      sparrow=1
      ;;
    a)
      aracne=1
      ;;
    w)
      wgcna=1
      ;;
    l)
      lasso=1
      ;;
    r)
      ridge=1
      ;;
    g)
      genie3=1
      ;;
    t)
      tigress=1
      ;;
    v)
      sva=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "synapseIdFile: $synapseIdFile"
echo "codeUrlFile: $codeUrlFile"
echo "sparrow: $sparrow"
echo "aracne: $aracne"
echo "wgcna: $wgcna"
echo "lasso: $lasso"
echo "ridge: $ridge"
echo "genie3: $genie3"
echo "tigress: $tigress"
echo "sva: $sva"
echo "projectId: $projectId"

if [ $sparrow -eq "1" ]; then
  #mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowMPI"
  Rscript 
fi
