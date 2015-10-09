#!/bin/bash

###bash script to build networks on an EC2 starcluster instance using the metaNet R package
###Author: Benjamin A Logsdon, 2015

#if sparrow:
if [ $sparrowZ -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowZ" $outputpath
  aws s3 mv $outputpath/result_sparrowZ.rda $s3
fi

if [ $sparrow2Z -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrow2Z" $outputpath
  aws s3 mv $outputpath/result_sparrow2Z.rda $s3
fi

if [ $sparrow2ZFDR -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrow2ZFDR" $outputpath
  aws s3 mv $outputpath/result_sparrow2ZFDR.rda $s3
fi

#if aracne
if [ $aracne -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "aracne" "NULL" $outputpath
  aws s3 mv $outputpath/result_aracne.rda $s3
fi

if [ $aracneFull -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "aracne" 1 $outputpath
  aws s3 mv $outputpath/result_aracneFull.rda $s3
fi

if [ $correlation -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "correlation" "NULL" $outputpath
  aws s3 mv $outputpath/result_correlation.rda $s3
fi

if [ $correlationBonferroni -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "correlationBonferroni" "NULL" $outputpath
  aws s3 mv $outputpath/result_correlationBonferroni.rda $s3
fi

if [ $correlationFDR -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "correlationFDR" "NULL" $outputpath
  aws s3 mv $outputpath/result_correlationFDR.rda $s3
fi

#if wgcna
if [ $wgcna -eq "1" ]; then
  Rscript buildOtherNet.R $dataFile $pathv "wgcna" "NULL" $outputpath
  aws s3 mv $outputpath/result_wgcna.rda $s3
fi

#if lasso
if [ $lassoBIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoBIC" $outputpath
  aws s3 mv $outputpath/result_lassoBIC.rda $s3
fi

if [ $lassoAIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoAIC" $outputpath
  aws s3 mv $outputpath/result_lassoAIC.rda $s3
fi

if [ $lassoCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCV1se" $outputpath
  aws s3 mv $outputpath/result_lassoCV1se.rda $s3
fi

if [ $lassoCVmin -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCVmin" $outputpath
  aws s3 mv $outputpath/result_lassoCVmin.rda $s3
fi

#if ridge
if [ $ridgeBIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeBIC" $outputpath
  aws s3 mv $outputpath/result_ridgeBIC.rda $s3
fi

if [ $ridgeAIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeAIC" $outputpath
  aws s3 mv $outputpath/result_ridgeAIC.rda $s3
fi

if [ $ridgeCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCV1se" $outputpath
  aws s3 mv $outputpath/result_ridgeCV1se.rda $s3
fi

if [ $ridgeCVmin -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCVmin" $outputpath
  aws s3 mv $outputpath/result_ridgeCVmin.rda $s3
fi

if [ $elasticNetCVmin -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "elasticNetCVmin" $outputpath
  aws s3 mv $outputpath/result_elasticNetCVmin.rda $s3
fi

if [ $elasticNetCV1se -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "elasticNetCV1se" $outputpath
  aws s3 mv $outputpath/result_elasticNetCV1se.rda $s3
fi

if [ $elasticNetAIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "elasticNetAIC" $outputpath
  aws s3 mv $outputpath/result_elasticNetAIC.rda $s3
fi

if [ $elasticNetBIC -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "elasticNetBIC" $outputpath
  aws s3 mv $outputpath/result_elasticNetBIC.rda $s3
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

#if tigress
if [ $tigressRootN -eq "1" ]; then
  mpirun -np 1 Rscript buildMpiNet.R $dataFile $((numberCore-1)) $pathv "tigressRootN" $outputpath
  aws s3 mv $outputpath/result_tigressRootN.rda $s3
fi
