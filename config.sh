#!/bin/bash

#bucket name
bucket="metanetworksynpasetestbucket"

#full s3 path where networks will go
s3="s3://$bucket/testNetwork/"

#location of data file
dataFile="/shared/network/cranioRNAseq.csv"

#output path for temporary result file prior to pushing to s3/synapse
outputpath="/shared/network/"

#path within s3
s3b="testNetwork"

#id of folder on Synapse that files will go to
parentId="syn7209613"

#id of folder with networks to combine (for buildConsensus)
networkFolderId="syn7187284"

#path to error output
errorOutput="$outputpath/errorLogs"

#path to out output
outOutput="$outputpath/outLogs"
