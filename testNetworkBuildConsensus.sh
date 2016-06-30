#!/bin/sh
#number of cores to reserve for job
nthreads=1

#full s3 path where networks will go
s3="s3://metanetworks/testNetwork/"

#location of data file
dataFile="/shared/testNetwork/testData.csv"

#location of metanetwork synapse scripts
pathv="/shared/metanetworkSynapse/"

#output path for temporary result file prior to pushing to s3/synapse
outputpath="/local/testNetwork/"

#path within s3
s3b="testNetwork"

#id of folder with networks to combine
networkFolderId="syn5706584"

#id of folder on Synapse that file will go to
parentId="syn5646308"

#path to csv file with annotations to add to file on Synapse
annotationFile="/shared/testNetwork/annoFile.txt"

provenanceFile="/shared/testNetwork/provenanceFile.txt"

#path to error output
errorOutput="/shared/testNetwork/Aggregationerror.txt"

#path to out output
outOutput="/shared/testNetwork/Aggregationout.txt"

#job script name
jobname="testNetworkaggregation"

qsub -v s3=$s3,dataFile=$dataFile,pathv=$pathv,outputpath=$outputpath,s3b=$s3b,parentId=$parentId,annotationFile=$annotationFile,provenanceFile=$provenanceFile,networkFolderId=$networkFolderId -pe orte $nthreads -S /bin/bash -V -cwd -N $jobname -e $errorOutput -o $outOutput $pathv/buildConsensus.sh
