#!/bin/bash

. ./config.sh

#number of cores to reserve for job
nthreads=1

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/annoFile.txt"

#path to csv file with provenance to add to file on synapse
provenanceFile="$outputpath/provenanceFile.txt"

#path to error output
errorOutput="$outputpath/marginalerror.txt"

#path to out output
outOutput="$outputpath/marginalout.txt"

#job script name
jobname="networkMarginal"

echo "qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,c3net=1,mrnet=1,wgcnaTOM=1,sparrowZ=0,lassoCV1se=0,ridgeCV1se=0,genie3=0,tigress=0,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $jobname -e $errorOutput -o $outOutput $pathv/buildNet.sh"

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,c3net=1,mrnet=1,wgcnaTOM=1,sparrowZ=0,lassoCV1se=0,ridgeCV1se=0,genie3=0,tigress=0,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $jobname -e $errorOutput -o $outOutput $pathv/buildNet.sh

#s3=$s3 dataFile=$dataFile pathv=$pathv c3net=1 mrnet=1 wgcnaTOM=1 sparrowZ=0 lassoCV1se=0 ridgeCV1se=0 genie3=0 tigress=0 numberCore=$nthreads outputpath=$outputpath s3b=$s3b parentId=$parentId annotationFile=$annotationFile provenanceFile=$provenanceFile $pathv/pushNetS3.sh
