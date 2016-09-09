#!/bin/sh

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

#number of cores to reserve for job
nthreads=8

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/buildConsensusAnnoFile.txt"

provenanceFile="$outputpath/buildConsensusProvenanceFile.txt"

#job script name
jobname="networkAggregation"

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,networkFolderId=$networkFolderId -pe mpi $nthreads -S /bin/bash -V -cwd -N $jobname -e $errorOutput/Aggregationerror.txt -o $outOutput/Aggregationout.txt $pathv/buildConsensus.sh

#s3=$s3 dataFile=$dataFile pathv=$pathv outputpath=$outputpath s3b=$s3b parentId=$parentId annotationFile=$annotationFile provenanceFile=$provenanceFile networkFolderId=$networkFolderId bucket=$bucket $pathv/pushNetS3.sh
