#!/bin/bash

#bucket name
bucket="metanetworks"

#full s3 path where networks will go
s3="s3://${bucket}/CRANIO2/"

#location of data file
dataFile="/shared/network/cranioRNAseq.csv"

#output path for temporary result file prior to pushing to s3/synapse
outputpath="/shared/network/"

#path within s3
s3b="CRANIO2"

#id of folder on Synapse that files will go to
parentId="syn7187284"

#id of folder with networks to combine (for buildConsensus)
networkFolderId="syn7187284"

#path to error output
errorOutput="$outputpath/errorLogs"

#path to out output
outOutput="$outputpath/outLogs"
