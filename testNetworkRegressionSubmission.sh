#!/bin/bash

. ./config.sh

#number of cores to reserve for job
nthreads=8

#path to csv file with annotations to add to file on Synapse
annotationFile="$outputpath/annoFile.txt"

#path to csv file with provenance to add to file on synapse
provenanceFile="$outputpath/provenanceFile.txt"

#job script name
jobname="networkRegression"

#prefixes
sparrowZ="sparrow"
lassoCV1se="lasso"
ridgeCV1se="ridge"
genie3="genie"
tigress="tigress"

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nSparrowThreads -S /bin/bash -V -cwd -N $sparrowZ -e "$outputpath/${sparrowZ}error.txt" -o "$outputpath/${sparrowZ}out.txt" $pathv/networkScripts/sparrow.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $lassoCV1se -e "$outputpath/${lassoCV1se}error.txt" -o "$outputpath/${lassoCV1se}out.txt" $pathv/networkScripts/lasso.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $ridgeCV1se -e "$outputpath/${ridgeCV1se}error.txt" -o "$outputpath/${ridgeCV1se}out.txt" $pathv/networkScripts/ridge.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $genie3 -e "$outputpath/${genie3}error.txt" -o "$outputpath/${genie3}out.txt" $pathv/networkScripts/genie3.sh

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,numberCore=$nthreads,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile -pe mpi $nthreads -S /bin/bash -V -cwd -N $tigress -e "$outputpath/${tigress}error.txt" -o "$outputpath/${tigress}out.txt" $pathv/networkScripts/tigress.sh

#s3=$s3 dataFile=$dataFile pathv=$pathv c3net=0 mrnet=0 wgcnaTOM=0 sparrowZ=1 lassoCV1se=1 ridgeCV1se=1 genie3=1 tigress=1 numberCore=$nthreads outputpath=$outputpath s3b=$s3b parentId=$parentId annotationFile=$annotationFile provenanceFile=$provenanceFile bucket=$bucket $pathv/pushNetS3.sh
