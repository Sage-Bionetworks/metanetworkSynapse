#!/bin/bash

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

#v whether or not sva normalization was run
#p project id of where to upload results
#n number of cores in cluster

sparrow=0
aracne=0
wgcna=0
lasso=0
ridge=0
genie3=0
tigress=0
sva=0

while getopts ":d:y:c:p:n:sawlrgtv" opt; do
  case $opt in
    d)
      dataFile=$OPTARG
      ;;
    y)
      synapseIdFile=$OPTARG
      ;;
    c)
      codeUrlFile=$OPTARG
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
    p)
      projectId=$OPTARG
      ;;
    n)
      numberCore=$OPTARG
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

echo "dataFile: $dataFile"
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
echo "numberCore: $numberCore"

#$ -S /bin/bash
#$ -V
#$ -cwd
#$ -N Job1
#$ -pe orte $numberCore

#if sparrow:
if [ $sparrow -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiSparrowNet.R $dataFile $((numberCore-1)) "/shared/CMC/CMCSPARROW/"
fi

#if aracne
if [ $aracne -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiSparrowNet.R $dataFile $((numberCore-1)) "/shared/CMC/CMCSPARROW/"
fi

#if wgcna
if [ $wgcna -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiSparrowNet.R $dataFile $((numberCore-1)) "/shared/CMC/CMCSPARROW/"
fi

#if lasso
if [ $lasso -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiSparrowNet.R $dataFile $((numberCore-1)) "/shared/CMC/CMCSPARROW/"
fi

#if ridge
if [ $ridge -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiSparrowNet.R $dataFile $((numberCore-1)) "/shared/CMC/CMCSPARROW/"
fi

#if genie3
if [ $genie3 -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiSparrowNet.R $dataFile $((numberCore-1)) "/shared/CMC/CMCSPARROW/"
fi

#if tigress
if [ $tigress -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiSparrowNet.R $dataFile $((numberCore-1)) "/shared/CMC/CMCSPARROW/"
fi