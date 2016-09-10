#!/bin/bash

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

. $pathv/config.sh

#number of cores to reserve for building networks
nthreads=1

#number of cores to reserve for pushing networks to S3/Synapse
nthreadsPush=1

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/annoFile.txt"

#path to csv file with provenance to add to file on synapse
provenanceFile="$outputpath/provenanceFile.txt"

### build nets ###

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "c3net" -e "$errorOutput/c3error.txt" -o "$outOutput/c3out.txt" $pathv/networkScripts/c3net.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "mrnet" -e "$errorOutput/mrneterror.txt" -o "$outOutput/mrnetout.txt" $pathv/networkScripts/mrnet.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N "wgcnaTOM" -e "$errorOutput/wgcnaerror.txt" -o "$outOutput/wgcnaout.txt" $pathv/networkScripts/wgcnaTOM.sh

### push nets ###

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "c3net" -N "push-c3net" -e "$errorOutput/push/c3error.txt" -o "$outOutput/push/c3out.txt" $pathv/pushScripts/c3net.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "mrnet" -N "push-mrnet" -e "$errorOutput/push/mrerror.txt" -o "$outOutput/push/mrout.txt" $pathv/pushScripts/mrnet.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "mrnet" -N "push-aracne" -e "$errorOutput/push/aracneerror.txt" -o "$outOutput/push/aracneout.txt" $pathv/pushScripts/aracne.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,bucket=$bucket -pe mpi $nthreadsPush -S /bin/bash -V -cwd -hold_jid "wgcnaTOM" -N "push-wgcnaTOMnet" -e "$errorOutput/push/wgcnaTOMerror.txt" -o "$outOutput/push/wgcnaTOMout.txt" $pathv/pushScripts/wgcnaTOM.sh
