#!/bin/bash

###bash script to push networks to Synapse after running buildNet.sh
###Author: Benjamin A Logsdon, 2015


#syn id of parentId to post networks to
#file with syn ids of data used to run network analysis
#file with code urls of code used to run network analysis
#network inference method
#normalization method (if applicable)
#tissue type of data used to build networks
#disease state
#organism
#what type of edge summary is present in file
sparrow=0
aracne=0
wgcna=0
lasso=0
ridge=0
genie3=0
tigress=0

while getopts ":p:c:g:sawlrgtv:o:d:u:" opt; do
  case $opt in
    p)
      parentId=$OPTARG
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
      normalization=$OPTARG
      ;;
    o)
      organism=$OPTARG
      ;;
    d)
      disease=$OPTARG
      ;;
    u)
      tissueType=$OPTARG
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
echo "normalization: $normalization"
echo "parentId: $parentId"

if [ $sparrow -eq "1" ]; then
  Rscript pushNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "sparrow" $normalization $tissueType $disease $organism "zstatistic"
fi

if [ $aracne -eq "1" ]; then
  Rscript pushNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "aracne" $normalization $tissueType $disease $organism "indicator"
fi

if [ $wgcna -eq "1" ]; then
  Rscript pushNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "wgcna" $normalization $tissueType $disease $organism "weight"
fi

if [ $lasso -eq "1" ]; then
  Rscript pushNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "lasso" $normalization $tissueType $disease $organism "weight"
fi

if [ $ridge -eq "1" ]; then
  Rscript pushNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "ridge" $normalization $tissueType $disease $organism "weight"
fi

if [ $genie3 -eq "1" ]; then
  Rscript pushNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "genie3" $normalization $tissueType $disease $organism "weight"
fi

if [ $tigress -eq "1" ]; then
  Rscript pushNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "tigress" $normalization $tissueType $disease $organism "weight"
fi
