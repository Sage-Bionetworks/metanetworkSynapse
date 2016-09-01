#!/bin/bash

###bash script to build networks on an EC2 starcluster instance using the metanetwork R package
###Authors: Benjamin A Logsdon, Thanneer M Perumal 2016

#if sparrow:
if [ $sparrowZ -eq "1" ]; then
  #build network
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowZ" $outputpath
  #compute md5
  Rscript $pathv/computeMD5.R $outputpath/sparrowZNetwork.csv $outputpath/sparrowtempmd5.out
fi

if [ $mrnet -eq "1" ]; then
  #build network
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "mrnetWrapper" "NULL" $outputpath
  #compute md5
  Rscript $pathv/computeMD5.R $outputpath/mrnetNetwork.csv $outputpath/mrnettempmd5.out
  Rscript $pathv/computeMD5.R $outputpath/aracneNetwork.csv $outputpath/aracnetempmd5.out

fi

if [ $c3net -eq "1" ]; then
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "c3netWrapper" "NULL" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/c3netNetwork.csv $outputpath/c3nettempmd5.out

fi

#if lasso
if [ $lassoCV1se -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCV1se" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/lassoCV1seNetwork.csv $outputpath/lassoCV1setempmd5.out

fi

#if ridge
if [ $ridgeCV1se -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCV1se" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/ridgeCV1seNetwork.csv $outputpath/ridgetempmd5.out

fi

#if genie3
if [ $genie3 -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "genie3" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/genie3Network.csv $outputpath/genie3tempmd5.out

fi

#if tigress
if [ $tigress -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "tigress" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/tigressNetwork.csv $outputpath/tigresstempmd5.out

fi


if [ $wgcnaTOM -eq "1" ]; then
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "wgcnaTOM" "NULL" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/wgcnaTopologicalOverlapMatrixNetwork.csv $outputpath/wgcnaTOMtempmd5.out

  Rscript $pathv/computeMD5.R $outputpath/wgcnaSoftThresholdNetwork.csv $outputpath/wgcnaSoftThresholdtempmd5.out

fi
