#!/bin/bash

# output path for temporary result file prior to pushing to s3/synapse
outputpath="/shared/network/"

# location of Expression data on Synapse
dataSynId="syn7984097"

# id of folder on Synapse that network files will go to
parentId="syn7984378"

# path to error output
errorOutput="$outputpath/errorLogs"

# path to out output
outOutput="$outputpath/outLogs"

# commit message
versionCommitMessage="rosmap rank consensus with max number of edges being 2e5"
