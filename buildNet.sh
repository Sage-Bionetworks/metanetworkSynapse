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
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowZ"
fi

if [ $sparrow2Z -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrow2Z"
fi

if [ $sparrow2ZFDR -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrow2ZFDR"
fi

#if aracne
if [ $aracne -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "aracne" "NULL"
fi

if [ $aracneFull -eq "1"]; then
  Rscript buildOtherNet.R $dataFile $pathv "aracne" 1
fi

if [ $correlationBonferroni -eq "1"]; then
  Rscript buildOtherNet.R $dataFile $pathv "correlationBonferroni" "NULL"
fi

if [ $correlationFDR -eq "1"]; then
  Rscript buildOtherNet.R $dataFile $pathv "correlationFDR" "NULL"
fi

#if wgcna
if [ $wgcna -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "wgcna" "NULL"
fi

#if lasso
if [ $lassoBIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoBIC"
fi

if [ $lassoAIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoAIC"
fi

if [ $lassoCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCV1se"
fi

if [ $lassoCVmin -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCVmin"
fi

#if ridge
if [ $ridgeBIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeBIC"
fi

if [ $ridgeAIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeAIC"
fi

if [ $ridgeCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCV1se"
fi

if [ $ridgeCVmin -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCVmin"
fi

#if genie3
if [ $genie3 -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "genie3"
fi

#if tigress
if [ $tigress -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "tigress"
fi