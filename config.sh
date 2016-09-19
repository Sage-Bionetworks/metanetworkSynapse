#!/bin/bash

#location of data file
dataFile="/shared/network/expression.tsv"

#output path for temporary result file prior to pushing to s3/synapse
outputpath="/shared/network/"

#id of folder on Synapse that files will go to
parentId="syn7254073"

#id of folder with networks to combine (for buildConsensus)
networkFolderId="syn7254073"

#path to error output
errorOutput="$outputpath/errorLogs"

#path to out output
outOutput="$outputpath/outLogs"
