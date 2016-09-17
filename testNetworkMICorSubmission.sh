#!/bin/bash

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

#number of cores to reserve for building networks
nthreads=16

#number of cores to reserve for pushing networks to S3/Synapse
nthreadsPush=1

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/annoFile.txt"

#path to csv file with provenance to add to file on synapse
provenanceFile="$outputpath/provenanceFile.txt"

### build nets ###

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "c3net" -e "$errorOutput/c3error.txt" -o "$outOutput/c3out.txt" $pathv/networkScripts/c3net.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "mrnet" -e "$errorOutput/mrneterror.txt" -o "$outOutput/mrnetout.txt" $pathv/networkScripts/mrnet.sh

qsub -r yes -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "wgcnaTOM" -e "$errorOutput/wgcnaerror.txt" -o "$outOutput/wgcnaout.txt" $pathv/networkScripts/wgcnaTOM.sh
