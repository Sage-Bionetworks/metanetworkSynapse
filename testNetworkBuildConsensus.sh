#!/bin/sh

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

#number of cores to reserve for job
nthreads=8

#number of cores to reserve for pushing networks to S3/Synapse
nthreadsPush=1

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/buildConsensusAnnoFile.txt"

provenanceFile="$outputpath/buildConsensusProvenanceFile.txt"

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,networkFolderId=$networkFolderId -pe mpi $nthreads -S /bin/bash -V -cwd -N "buildConsensus" -e $errorOutput/errorLogs/buildConsensuserror.txt -o $outOutput/outLogs/buildConsensusout.txt $pathv/networkScripts/buildConsensus.sh

#qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,networkFolderId=$networkFolderId,bucket=$bucket -hold_jid = "buildConsensus" -pe mpi $nthreadsPush -S /bin/bash -V -cwd -N "push-rankConsensus" -e $errorOutput/errorLogs/pushrankConsensuserror.txt -o $outOutput/outLogs/pushrankConsensusout.txt $pathv/pushScripts/rankConsensus.sh

#qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,networkFolderId=$networkFolderId,bucket=$bucket -hold_jid "buildConsensus" -pe mpi $nthreadsPush -S /bin/bash -V -cwd -N "push-bic" -e $errorOutput/errorLogs/pushBICerror.txt -o $outOutput/outLogs/pushBICout.txt $pathv/pushScripts/bic.sh
