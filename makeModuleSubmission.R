# Function to make submission scripts for module generation with sge

#### Get inputs ####
# Sample query to get all bic network ids
# tmp = synQuery('select name,id from file where projectId == "syn5584871" and fileType == "csv" and 
#                dataType == "analysis" and normalizationStatus	== "TRUE" and analysisType	== "statisticalNetworkReconstruction" and
#                method	== "bic"')
bic.net.ids = c(rosmap.ad = 'syn6188448', rosmap.nci = 'syn6188212')
rankCons.net.ids = c(rosmap.ad = 'syn6188446', rosmap.nci = 'syn6188210')

module.methods = c('CFinder', 'GANXiS', 'fast_greedy', 'hclust', 'infomap', 'label_prop', 
                   'linkcommunities', 'louvain', 'spinglass', 'walktrap');
module.exec.paths = c('/shared/Github/metanetworkSynapse/CFinder-2.0.6--1448/',
                      '/shared/Github/metanetworkSynapse/GANXiS_v3.0.2/',
                      rep('./', length(module.methods)-2))

repository.name = 'th1vairam/metanetworkSynapse'
branch.name = 'modules_dev'
file.name = 'buildModules.R'  

synapse.config.path = '/shared/synapseConfig'
r.library.path = '/shared/rlibs'

# Make submission directory
system('mkdir ./submission.scripts')

# Open a master template file to store submission commands to sge
fp = file('./submission.modules.sh', open = 'w+')
writeLines('#!/bin/bash', con = fp, sep = '\n')

# Create submission scripts for each network each method
objs = mapply(function(bicId, rankId, con, modMethods, moduleExecPaths, repositoryName,
                       branchName, fileName, synapseConfigPath, rLibPath){
  obj = mapply(function(modMethod, moduleExecPath, bicId, rankId, con, repositoryName, branchName, 
                        fileName, synapseConfigPath, rLibPath){
    fp1 = file(paste0('./submission.scripts/', bicId, '.', rankId, '.', modMethod, '.sh'), open = 'w+')
    writeLines('#!/bin/bash', con = fp1, sep = '\n')
    writeLines(paste('Rscript -e "source(\'buildModules.R\')"', bicId,  rankId, modMethod, moduleExecPath, repositoryName,
                     branchName, fileName, synapseConfigPath, rLibPath), con = fp1, sep = '\n')
    close(fp1)
    
    writeLines(paste('qsub -cwd -V', 
                     '-o', paste0('./submission.scripts/', bicId, '.', rankId, '.', modMethod, '.out'),
                     '-e', paste0('./submission.scripts/', bicId, '.', rankId, '.', modMethod, '.err'), 
                     paste0('./submission.scripts/', bicId, '.', rankId, '.', modMethod, '.sh')),
               con = con, sep = '\n')
  }, modMethods, moduleExecPaths,
               MoreArgs = list(bicId, rankId, con, repositoryName, branchName, fileName, 
                               synapseConfigPath, rLibPath), SIMPLIFY = FALSE)
},bic.net.ids, rankCons.net.ids,
       MoreArgs = list(con = fp, modMethods = module.methods, moduleExecPaths = module.exec.paths,
                       repositoryName = repository.name, branchName = branch.name, fileName = file.name,
                       synapseConfigPath = synapse.config.path, rLibPath = r.library.path), SIMPLIFY = FALSE)

close(fp)
