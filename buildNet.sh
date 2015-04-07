#!/bin/bash

###bash script to build networks on an EC2 starcluster instance using the metaNet R package
###Author: Benjamin A Logsdon, 2015

#d data file

#y file with syn ids used to run analysis
#c file with code urls used to run analysis

#s run sparrow
#a run aracne
#w run wgcna
#l run lasso
#r run ridge
#g run genie3
#t run tigress

#n number of cores in cluster

echo "dataFile: $dataFile"
echo "sparrow: $sparrow"
echo "aracne: $aracne"
echo "wgcna: $wgcna"
echo "lasso: $lasso"
echo "ridge: $ridge"
echo "genie3: $genie3"
echo "tigress: $tigress"
echo "numberCore: $numberCore"

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N Job1
#$ -pe orte $numberCore
#$ -e /shared/CMC/error.txt
#$ -o /shared/CMC/out.txt

#if sparrow:
if [ $sparrow -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowMPI"
fi

#if aracne
if [ $aracne -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "aracne"
fi

#if wgcna
if [ $wgcna -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "wgcna"
fi

#if lasso
if [ $lasso -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoBICMPI"
fi

#if ridge
if [ $ridge -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeBICMPI"
fi

#if genie3
if [ $genie3 -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "genie3MPI"
fi

#if tigress
if [ $tigress -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "tigressMPI"
fi