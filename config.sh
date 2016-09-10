#!/bin/bash

#bucket name
bucket="metanetworksynpasetestbucket"

#full s3 path where networks will go
s3="s3://$bucket/mo-tests/"

#location of data file
dataFile="/shared/testNetwork/testData.csv"

#output path for temporary result file prior to pushing to s3/synapse
outputpath="/shared/testNetwork/"

#path within s3
s3b="mo-tests"

#id of folder on Synapse that files will go to
parentId="syn7222474"

#id of folder with networks to combine (for buildConsensus)
networkFolderId="syn7222474"

#path to error output
errorOutput="$outputpath/errorLogs"

#path to out output
outOutput="$outputpath/outLogs"
