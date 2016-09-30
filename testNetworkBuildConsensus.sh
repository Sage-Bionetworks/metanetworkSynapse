#!/bin/sh

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

#number of cores to reserve for job
nthreads=16

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/buildConsensusAnnoFile.txt"

provenanceFile="$outputpath/buildConsensusProvenanceFile.txt"

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,networkFolderId=$parentId -pe mpi $nthreads -S /bin/bash -V -cwd -N "buildConsensus" -e $errorOutput/buildConsensuserror.txt -o $outOutput/buildConsensusout.txt $pathv/networkScripts/buildConsensus.sh
