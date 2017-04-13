# Function to make submission scripts for module generation with sge

#### Get inputs ####
bic.net.ids = c(MayoRNAseq.TCX = 'syn8276546', MayoRNAseq.CBE = 'syn8281722', MSBB.IFG = 'syn8349785', 
                MSBB.PHG = 'syn8345109', MSBB.STG = 'syn8343704', MSBB.FP = 'syn8340017', MayoEGWAS.TCX = 'syn8419174',
                MayoEGWAS.CBE = 'syn8421913')

rankCons.net.ids = c(MayoRNAseq.TCX = 'syn8276556', MayoRNAseq.CBE = 'syn8281727',  MSBB.IFG = 'syn8349787',
                     MSBB.PHG = 'syn8345270', MSBB.STG = 'syn8343716', MSBB.FP = 'syn8340019', MayoEGWAS.TCX = 'syn8419231',
                     MayoEGWAS.CBE = 'syn8421921')

module.methods = c('CFinder', 'GANXiS', 'fast_greedy', 
                   'label_prop', 'louvain', 'spinglass',
                   'walktrap', 'infomap', 'linkcommunities');
module.exec.paths = c('/shared/CFinder-2.0.6--1448/',
                      '/shared/GANXiS_v3.0.2/',
                      replicate(6, './'))

repository.name = 'th1vairam/metanetworkSynapse'
branch.name = 'modules_dev'
file.name = 'buildModules.R'  

synapse.config.path = '/shared/synapseConfig'
r.library.path = '/shared/rlibs'

# Make submission directory
system('rm -rf ./submission.scripts')
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
                     '-pe mpi 4',
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
