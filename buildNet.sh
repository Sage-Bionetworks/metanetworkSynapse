#!/bin/bash

###bash script to build networks on an EC2 starcluster instance using the metanetwork R package
###Authors: Benjamin A Logsdon, Thanneer M Perumal 2016

#if sparrow:
if [ $sparrowZ -eq "1" ]; then
  #build network
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowZ" $outputpath
  #compute md5
  Rscript $pathv/computeMD5.R $outputpath/sparrowZNetwork.csv $outputpath/tempmd5.out
  #push to s3
  aws s3 mv $outputpath/sparrowZNetwork.csv $s3
  #link file to synapse, add provenance, add annotations
  Rscript $pathv/s3LinkToSynapse.R $s3b/sparrowZNetwork.csv $outputpath/tempmd5.out $parentId $annotationFile $provenanceFile
fi

if [ $mrnet -eq "1" ]; then
  #build
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "mrnetWrapper" "NULL" $outputpath
  aws s3 mv $outputpath/mrnetNetwork.csv $s3
fi

if [ $c3net -eq "1" ]; then
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "c3netWrapper" "NULL" $outputpath
  aws s3 mv $outputpath/c3netNetwork.csv $s3
fi

#if lasso
if [ $lassoCV1se -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCV1se" $outputpath
  aws s3 mv $outputpath/lassoCV1seNetwork.csv $s3
fi

#if ridge
if [ $ridgeCV1se -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCV1se" $outputpath
  aws s3 mv $outputpath/ridgeCV1seNetwork.csv $s3
fi

#if genie3
if [ $genie3 -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "genie3" $outputpath
  aws s3 mv $outputpath/genie3Network.csv $s3
fi

#if tigress
if [ $tigress -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "tigress" $outputpath
  aws s3 mv $outputpath/tigressNetwork.csv $s3
fi

#if aracne
if [ $aracne -eq "1" ]; then
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "aracne" 1 $outputpath
  aws s3 mv $outputpath/aracneNetwork.csv $s3
fi

#if wgcna
if [ $wgcnaST -eq "1" ]; then
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "wgcnaSoftThreshold" "NULL" $outputpath
  aws s3 mv $outputpath/wgcnaSoftThresholdNetwork.csv $s3
fi

if [ $wgcnaTOM -eq "1" ]; then
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "wgcnaTOM" "NULL" $outputpath
  aws s3 mv $outputpath/wgcnaTopologicalOverlapMatrixNetwork.csv $s3
fi