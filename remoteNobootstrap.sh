#!/bin/bash

. /shared/metanetworkSynapse/config.sh
# actual network
mkdir -p /shared/network/errorLogs/; mkdir -p /shared/network/outLogs/
cd /shared/network/
git clone https://github.com/philerooski/brainRegNetwork.git
Rscript -e "library(devtools); install_github('blogsdon/utilityFunctions')"
Rscript brainRegNetwork/getData.R $dataSynId
echo "provenance,executed" > /shared/network/provenanceFile.txt
echo "${dataSynId},FALSE" >> /shared/network/provenanceFile.txt
echo "https://github.com/philerooski/brainRegNetwork/blob/master/getData.R,TRUE" >> /shared/network/provenanceFile.txt
echo -e "fileType,csv\ndataType,analysis\nanalysisType,statisticalNetworkReconstruction\nnormalizationStatus,TRUE" > /shared/network/annoFile.txt
sh /shared/metanetworkSynapse/submission.sh
