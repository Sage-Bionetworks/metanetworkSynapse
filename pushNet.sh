#!/bin/bash

###bash script to push networks to Synapse after running buildNet.sh
###Author: Benjamin A Logsdon, 2016

#syn id of parentId to post networks to
#file with syn ids of data used to run network analysis
#file with code urls of code used to run network analysis
#network inference method
#normalization method (if applicable)
#tissue type of data used to build networks
#disease state
#organism
#what type of edge summary is present in file

sparrow1=0 #d
aracne=0 #e
correlation=0 #f
lassoCV1se=0 #g
ridgeCV1se=0 #h
genie3=0 #i
tigress=0 #j
c3net=0 #k
mrnet=0 #l
wgcnaST=0 #m
wgcnaTOM=0 #n
rankconsensus=0 #o

while getopts ":a:b:c:defghijklmnor:s:t:u:vx:" opt; do
  case $opt in
    a)
      parentId=$OPTARG
      ;;
    b)
      codeUrlFile=$OPTARG
      ;;
    c)
      synapseIdFile=$OPTARG
      ;;
    d)
      sparrow1=1
      ;;
    e)
      aracne=1
      ;;
    f)
      correlation=1
      ;;
    g)
      lassoCV1se=1
      ;;
    h)
      ridgeCV1se=1
      ;;
    i)
      genie3=1
      ;;
    j)
      tigress=1
      ;;
    k)
      c3net=1
      ;;   
    l)
      mrnet=1
      ;;   
    m)
      wgcnaST=1
      ;;
    n)
      wgcnaTOM=1
      ;;      
    o)
      rankconsensus=1
      ;;
    r)
      normalization=$OPTARG
      ;;
    s)
      organism=$OPTARG
      ;;
    t)
      disease=$OPTARG
      ;;
    u)
      tissueType=$OPTARG
      ;;
    v)
      sparsity=1
      ;;
    x)
      outputpath=$OPTARG
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

if [ $sparrow1 -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "sparrow1" $normalization $tissueType $disease $organism "zstatistic"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "sparrow" $normalization $tissueType $disease $organism "zstatistic"  
fi

if [ $aracne -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "aracne" $normalization $tissueType $disease $organism "mi"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "aracne" $normalization $tissueType $disease $organism "indicator"  
fi

if [ $correlation -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "correlation" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "wgcna" $normalization $tissueType $disease $organism "weight"  
fi

if [ $lassoCV1se -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "lassoCV1se" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "lasso" $normalization $tissueType $disease $organism "weight"  
fi

if [ $ridgeCV1se -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "ridgeCV1se" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "ridge" $normalization $tissueType $disease $organism "weight"  
fi

if [ $genie3 -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "genie3" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "genie3" $normalization $tissueType $disease $organism "weight"  
fi

if [ $tigress -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "tigress" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "tigress" $normalization $tissueType $disease $organism "weight"  
fi

if [ $c3net -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "c3net" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "tigress" $normalization $tissueType $disease $organism "weight"  
fi

if [ $mrnet -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "mrnet" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "tigress" $normalization $tissueType $disease $organism "weight"  
fi

if [ $wgcnaST -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "wgcnaST" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "tigress" $normalization $tissueType $disease $organism "weight"  
fi

if [ $wgcnaTOM -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "wgcnaTOM" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "tigress" $normalization $tissueType $disease $organism "weight"  
fi

if [ $sparsity -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "sparsity" $normalization $tissueType $disease $organism "weight"
fi

if [ $rankconsensus -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "rankconsensus" $normalization $tissueType $disease $organism "weight"
fi

