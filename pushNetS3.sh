#!/bin/bash

###bash script to build networks on an EC2 starcluster instance using the metanetwork R package
###Authors: Benjamin A Logsdon, Thanneer M Perumal 2016

#if sparrow:
if [ $sparrowZ -eq "1" ]; then
  #push to s3
  aws s3 mv $outputpath/sparrowZNetwork.csv $s3
  #link file to synapse, add provenance, add annotations
  Rscript $pathv/s3LinkToSynapse.R $s3b/sparrowZNetwork.csv $outputpath/sparrowtempmd5.out $parentId $annotationFile $provenanceFile "sparrow"
fi

if [ $mrnet -eq "1" ]; then
  aws s3 mv $outputpath/mrnetNetwork.csv $s3
  #link file to Synapse, add provenance, add annotations
  Rscript $pathv/s3LinkToSynapse.R $s3b/mrnetNetwork.csv $outputpath/mrnettempmd5.out $parentId $annotationFile $provenanceFile "mrnet"

  aws s3 mv $outputpath/aracneNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/aracneNetwork.csv $outputpath/aracnetempmd5.out $parentId $annotationFile $provenanceFile "aracne"
fi

if [ $c3net -eq "1" ]; then
  aws s3 mv $outputpath/c3netNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/c3netNetwork.csv $outputpath/c3nettempmd5.out $parentId $annotationFile $provenanceFile "c3net"

fi

#if lasso
if [ $lassoCV1se -eq "1" ]; then
  aws s3 mv $outputpath/lassoCV1seNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/lassoCV1seNetwork.csv $outputpath/lassoCV1setempmd5.out $parentId $annotationFile $provenanceFile "lasso"

fi

#if ridge
if [ $ridgeCV1se -eq "1" ]; then
  aws s3 mv $outputpath/ridgeCV1seNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/ridgeCV1seNetwork.csv $outputpath/ridgetempmd5.out $parentId $annotationFile $provenanceFile "ridge"

fi

#if genie3
if [ $genie3 -eq "1" ]; then
  aws s3 mv $outputpath/genie3Network.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/genie3Network.csv $outputpath/genie3tempmd5.out $parentId $annotationFile $provenanceFile "genie3"

fi

#if tigress
if [ $tigress -eq "1" ]; then
  aws s3 mv $outputpath/tigressNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/tigressNetwork.csv $outputpath/tigresstempmd5.out $parentId $annotationFile $provenanceFile "tigress"

fi


if [ $wgcnaTOM -eq "1" ]; then
  aws s3 mv $outputpath/wgcnaTopologicalOverlapMatrixNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/wgcnaTopologicalOverlapMatrixNetwork.csv $outputpath/wgcnaTOMtempmd5.out $parentId $annotationFile $provenanceFile "wgcnaTopologicalOverlapMatrix"

  aws s3 mv $outputpath/wgcnaSoftThresholdNetwork.csv $s3

  Rscript $pathv/s3LinkToSynapse.R $s3b/wgcnaSoftThresholdNetwork.csv $outputpath/wgcnaSoftThresholdtempmd5.out $parentId $annotationFile $provenanceFile "wgcnaSoftThreshold"

fi
