#!/bin/bash

# output path for temporary result file prior to pushing to s3/synapse
outputpath="/shared/network/"

# location of Expression data on Synapse
dataSynId="syn8257637"

# id of folder on Synapse that network files will go to
parentId="syn8259323"

# path to error output
errorOutput="$outputpath/errorLogs"

# path to out output
outOutput="$outputpath/outLogs"

# commit message
versionCommitMessage="mayo rnaseq cerebellum rank consensus"
