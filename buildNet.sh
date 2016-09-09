#!/bin/bash

###bash script to build networks on an EC2 starcluster instance using the metanetwork R package
###Authors: Benjamin A Logsdon, Thanneer M Perumal 2016

#if sparrow:
if [ $sparrowZ -eq "1" ]; then
  #build network
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrowZ" $outputpath
  #compute md5
  Rscript $pathv/computeMD5.R $outputpath/sparrowZNetwork.csv $outputpath/sparrowtempmd5.out
  #push to s3
  aws s3 mv $outputpath/sparrowZNetwork.csv $s3
  #link file to synapse, add provenance, add annotations
  Rscript $pathv/s3LinkToSynapse.R $s3b/sparrowZNetwork.csv $outputpath/sparrowtempmd5.out $parentId $annotationFile $provenanceFile "sparrow"
fi


if [ $sparrow2Z -eq "1" ]; then
  #build network
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "sparrow2Z" $outputpath
  #compute md5
  Rscript $pathv/computeMD5.R $outputpath/sparrow2ZNetwork.csv $outputpath/sparrow2tempmd5.out
  #push to s3
  aws s3 mv $outputpath/sparrow2ZNetwork.csv $s3
  #link file to synapse, add provenance, add annotations
  Rscript $pathv/s3LinkToSynapse.R $s3b/sparrow2ZNetwork.csv $outputpath/sparrow2tempmd5.out $parentId $annotationFile $provenanceFile "sparrow2"
fi

if [ $mrnet -eq "1" ]; then
  #build network
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "mrnetWrapper" "NULL" $outputpath
  #compute md5
  Rscript $pathv/computeMD5.R $outputpath/mrnetNetwork.csv $outputpath/mrnettempmd5.out
  #push to s3
  aws s3 mv $outputpath/mrnetNetwork.csv $s3
  #link file to Synapse, add provenance, add annotations
  Rscript $pathv/s3LinkToSynapse.R $s3b/mrnetNetwork.csv $outputpath/mrnettempmd5.out $parentId $annotationFile $provenanceFile "mrnet"

  Rscript $pathv/computeMD5.R $outputpath/aracneNetwork.csv $outputpath/aracnetempmd5.out

  aws s3 mv $outputpath/aracneNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/aracneNetwork.csv $outputpath/aracnetempmd5.out $parentId $annotationFile $provenanceFile "aracne"
fi

if [ $c3net -eq "1" ]; then
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "c3netWrapper" "NULL" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/c3netNetwork.csv $outputpath/c3nettempmd5.out

  aws s3 mv $outputpath/c3netNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/c3netNetwork.csv $outputpath/c3nettempmd5.out $parentId $annotationFile $provenanceFile "c3net"

fi

#if lasso
if [ $lassoCV1se -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCV1se" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/lassoCV1seNetwork.csv $outputpath/lassoCV1setempmd5.out

  aws s3 mv $outputpath/lassoCV1seNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/lassoCV1seNetwork.csv $outputpath/lassoCV1setempmd5.out $parentId $annotationFile $provenanceFile "lassoCV1se"

fi

if [ $lassoAIC -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoAIC" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/lassoAICNetwork.csv $outputpath/lassoAICtempmd5.out

  aws s3 mv $outputpath/lassoAICNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/lassoAICNetwork.csv $outputpath/lassoAICtempmd5.out $parentId $annotationFile $provenanceFile "lassoAIC"

fi

if [ $lassoBIC -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoBIC" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/lassoBICNetwork.csv $outputpath/lassoBICtempmd5.out

  aws s3 mv $outputpath/lassoBICNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/lassoBICNetwork.csv $outputpath/lassoBICtempmd5.out $parentId $annotationFile $provenanceFile "lassoBIC"

fi

if [ $lassoCVmin -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "lassoCVmin" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/lassoCVminNetwork.csv $outputpath/lassoCVmintempmd5.out

  aws s3 mv $outputpath/lassoCVminNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/lassoCVminNetwork.csv $outputpath/lassoCVmintempmd5.out $parentId $annotationFile $provenanceFile "lassoCVmin"

fi

#if ridge
if [ $ridgeCV1se -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCV1se" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/ridgeCV1seNetwork.csv $outputpath/ridgeCV1setempmd5.out

  aws s3 mv $outputpath/ridgeCV1seNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/ridgeCV1seNetwork.csv $outputpath/ridgeCV1setempmd5.out $parentId $annotationFile $provenanceFile "ridgeCV1se"

fi

if [ $ridgeCVmin -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeCVmin" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/ridgeCVminNetwork.csv $outputpath/ridgeCVmintempmd5.out

  aws s3 mv $outputpath/ridgeCVminNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/ridgeCVminNetwork.csv $outputpath/ridgeCVmintempmd5.out $parentId $annotationFile $provenanceFile "ridgeCVmin"

fi

if [ $ridgeAIC -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeAIC" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/ridgeAICNetwork.csv $outputpath/ridgeAICtempmd5.out

  aws s3 mv $outputpath/ridgeAICNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/ridgeAICNetwork.csv $outputpath/ridgeAICtempmd5.out $parentId $annotationFile $provenanceFile "ridgeAIC"

fi

if [ $ridgeBIC -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "ridgeBIC" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/ridgeBICNetwork.csv $outputpath/ridgeBICtempmd5.out

  aws s3 mv $outputpath/ridgeBICNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/ridgeBICNetwork.csv $outputpath/ridgeBICtempmd5.out $parentId $annotationFile $provenanceFile "ridgeBIC"

fi

#if genie3
if [ $genie3 -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "genie3" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/genie3Network.csv $outputpath/genie3tempmd5.out

  aws s3 mv $outputpath/genie3Network.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/genie3Network.csv $outputpath/genie3tempmd5.out $parentId $annotationFile $provenanceFile "genie3"

fi

#if tigress
if [ $tigress -eq "1" ]; then
  mpirun -np 1 Rscript $pathv/buildMpiNet.R $dataFile $((numberCore-1)) $pathv "tigress" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/tigressNetwork.csv $outputpath/tigresstempmd5.out

  aws s3 mv $outputpath/tigressNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/tigressNetwork.csv $outputpath/tigresstempmd5.out $parentId $annotationFile $provenanceFile "tigress"

fi


if [ $wgcnaTOM -eq "1" ]; then
  Rscript $pathv/buildOtherNet.R $dataFile $pathv "wgcnaTOM" "NULL" $outputpath

  Rscript $pathv/computeMD5.R $outputpath/wgcnaTopologicalOverlapMatrixNetwork.csv $outputpath/wgcnaTOMtempmd5.out

  aws s3 mv $outputpath/wgcnaTopologicalOverlapMatrixNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/wgcnaTopologicalOverlapMatrixNetwork.csv $outputpath/wgcnaTOMtempmd5.out $parentId $annotationFile $provenanceFile "wgcnaTopologicalOverlapMatrix"

  Rscript $pathv/computeMD5.R $outputpath/wgcnaSoftThresholdNetwork.csv $outputpath/wgcnaSoftThresholdtempmd5.out

  aws s3 mv $outputpath/wgcnaSoftThresholdNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/wgcnaSoftThresholdNetwork.csv $outputpath/wgcnaSoftThresholdtempmd5.out $parentId $annotationFile $provenanceFile "wgcnaSoftThreshold"

fi
