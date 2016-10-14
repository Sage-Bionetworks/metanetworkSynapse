#!/bin/bash

# output path for temporary result file prior to pushing to s3/synapse
outputpath="/shared/network/"

# location of Expression data on Synapse
dataSynId="syn7342897"

# location of data file on master node
dataFile="$outputpath/Expression.csv"

# id of folder on Synapse that network files will go to
parentId="syn7342900"

# path to error output
errorOutput="$outputpath/errorLogs"

# path to out output
outOutput="$outputpath/outLogs"
