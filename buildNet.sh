#!/bin/bash

###bash script to build networks on an EC2 starcluster instance using the metaNet R package
###Author: Benjamin A Logsdon, 2015

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N Job1
#$ -e error.txt
#$ -o out.txt

#if sparrow:
if [ $sparrowZ -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowZ" $outputpath
fi

if [ $sparrow2Z -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrow2Z" $outputpath
fi

if [ $sparrow2ZFDR -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrow2ZFDR" $outputpath
fi

#if aracne
if [ $aracne -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "aracne" "NULL" $outputpath
fi

if [ $aracneFull -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "aracne" 1 $outputpath
fi

if [ $correlation -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "correlation" "NULL" $outputpath
fi

if [ $correlationBonferroni -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "correlationBonferroni" "NULL" $outputpath
fi

if [ $correlationFDR -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "correlationFDR" "NULL" $outputpath
fi

#if wgcna
if [ $wgcna -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "wgcna" "NULL" $outputpath
fi

#if lasso
if [ $lassoBIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoBIC" $outputpath
fi

if [ $lassoAIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoAIC" $outputpath
fi

if [ $lassoCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCV1se" $outputpath
fi

if [ $lassoCVmin -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCVmin" $outputpath
fi

#if ridge
if [ $ridgeBIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeBIC" $outputpath
fi

if [ $ridgeAIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeAIC" $outputpath
fi

if [ $ridgeCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCV1se" $outputpath
fi

if [ $ridgeCVmin -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCVmin" $outputpath
fi

if [ $elasticNetCVmin -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "elasticNetCVmin" $outputpath
fi

if [ $elasticNetCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "elasticNetCV1se" $outputpath
fi

if [ $elasticNetAIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "elasticNetAIC" $outputpath
fi

if [ $elasticNetBIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "elasticNetBIC" $outputpath
fi

#if genie3
if [ $genie3 -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "genie3" $outputpath
fi

#if tigress
if [ $tigress -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "tigress" $outputpath
fi