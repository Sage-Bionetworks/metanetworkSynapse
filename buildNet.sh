#!/bin/bash

###bash script to build networks on an EC2 starcluster instance using the metanetwork R package
###Authors: Benjamin A Logsdon, Thanneer M Perumal 2016

#if sparrow:
if [ $sparrowZ -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowZ" $outputpath
  aws s3 mv $outputpath/result_sparrowZ.rda $s3
  #run script linking to synapse
  #add annotations, provenance, etc...
fi



if [ $mrnet -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "mrnetWrapper" "NULL" $outputpath
  aws s3 mv $outputpath/result_mrnet.rda $s3
fi

if [ $c3net -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "c3netWrapper" "NULL" $outputpath
  aws s3 mv $outputpath/result_c3net.rda $s3
fi

#if lasso
if [ $lassoCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCV1se" $outputpath
  aws s3 mv $outputpath/result_lassoCV1se.rda $s3
fi

#if ridge
if [ $ridgeCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCV1se" $outputpath
  aws s3 mv $outputpath/result_ridgeCV1se.rda $s3
fi

#if genie3
if [ $genie3 -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "genie3" $outputpath
  aws s3 mv $outputpath/result_genie3.rda $s3
fi

#if tigress
if [ $tigress -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "tigress" $outputpath
  aws s3 mv $outputpath/result_tigress.rda $s3
fi

#if aracne
if [ $aracne -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "aracne" "NULL" $outputpath
  aws s3 mv $outputpath/result_aracne.rda $s3
fi

if [ $correlation -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "correlation" "NULL" $outputpath
  aws s3 mv $outputpath/result_correlation.rda $s3
fi

#if wgcna
if [ $wgcnaST -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "wgcnaSoftThreshold" "NULL" $outputpath
  aws s3 mv $outputpath/result_wgcnaST.rda $s3
fi

if [ $wgcnaTOM -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "wgcnaTOM" "NULL" $outputpath
  aws s3 mv $outputpath/result_wgcnaTOM.rda $s3
fi