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

sparrow1=0 #d
sparrow2=0 #e
aracne=0 #f
correlation=0 #g
lassoCV1se=0 #h
lassoCVmin=0 #i
lassoAIC=0 #j
lassoBIC=0 #k
ridgeCV1se=0 #l
ridgeCVmin=0 #m
ridgeAIC=0 #n
ridgeBIC=0 #o
genie3=0 #p
tigress=0 #q
sparsityconsensus=0 #y

while getopts ":a:b:c:defghijklmnopqyr:s:t:u:vx:" opt; do
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
      sparrow2=1
      ;;
    f)
      aracne=1
      ;;
    g)
      correlation=1
      ;;
    h)
      lassoCV1se=1
      ;;
    i)
      lassoCVmin=1
      ;;
    j)
      lassoAIC=1
      ;;
    k)
      lassoBIC=1
      ;;
    l)
      ridgeCV1se=1
      ;;
    m)
      ridgeCVmin=1
      ;;
    n)
      ridgeAIC=1
      ;;
    o)
      ridgeBIC=1
      ;;
    p)
      genie3=1
      ;;
    q)
      tigress=1
      ;;
    y)
      sparsityconsensus=1
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

if [ $sparrow2 -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "sparrow2" $normalization $tissueType $disease $organism "zstatistic"
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

if [ $lassoCVmin -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "lassoCVmin" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "lasso" $normalization $tissueType $disease $organism "weight"  
fi

if [ $lassoAIC -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "lassoAIC" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "lasso" $normalization $tissueType $disease $organism "weight"  
fi

if [ $lassoBIC -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "lassoBIC" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "lasso" $normalization $tissueType $disease $organism "weight"  
fi

if [ $ridgeCV1se -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "ridgeCV1se" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "ridge" $normalization $tissueType $disease $organism "weight"  
fi

if [ $ridgeCVmin -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "ridgeCVmin" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "ridge" $normalization $tissueType $disease $organism "weight"  
fi

if [ $ridgeAIC -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "ridgeAIC" $normalization $tissueType $disease $organism "weight"
  #Rscript pushSparseNetworkSynapse.R $parentId $synapseIdFile $codeUrlFile "ridge" $normalization $tissueType $disease $organism "weight"  
fi

if [ $ridgeBIC -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "ridgeBIC" $normalization $tissueType $disease $organism "weight"
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

if [ $sparsity -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "sparsity" $normalization $tissueType $disease $organism "weight"
fi

if [ $sparsityconsensus -eq "1" ]; then
  Rscript $outputpath $parentId $synapseIdFile $codeUrlFile "sparsityconsensus" $normalization $tissueType $disease $organism "weight"
fi
