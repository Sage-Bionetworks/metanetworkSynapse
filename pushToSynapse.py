import synapseclient
import argparse
import github
import csv
import os
import ConfigParser

"""Get permalink to git commit for a specific path.
written by Kenneth Daily (@kdaily)
"""
def getToken():
    """Authenticate using a token.

    """

    config = ConfigParser.ConfigParser()
    config.readfp(file(os.path.expanduser('~/.pygit')))

    mytoken = config.get('authentication', 'token')

    return mytoken

_base_raw = "https://raw.github.com"
_base_web = "https://github.com"

def makeRawPermalink(repo, commit, path):
    permalink = "%(base)s/%(repo)s/%(commit)s/%(path)s" % dict(base=_base_raw,
                                                               repo=repo,
                                                               commit=commit,
                                                               path=path)
    return permalink

def makeWebPermalink(repo, commit, path):
    permalink = "%(base)s/%(repo)s/blob/%(commit)s/%(path)s" % dict(base=_base_web,
                                                                    repo=repo,
                                                                    commit=commit,
                                                                    path=path)
    return permalink


def getPermalink(gh, repo, path, ref="master", raw=True):
    ## Get the repo
    repoobj = gh.get_repo(repo)

    ## Get a specific ref
    refobj = repoobj.get_git_ref("heads/%s" % ref)

    ## Get the commit object for this ref
    commit = repoobj.get_commit(refobj.object.sha)

    ## Get tree
    tree = repoobj.get_git_tree(commit.sha, recursive=True)

    try:
        myfile = filter(lambda x: x.path == path, tree.tree)[0]
    except IndexError as e:
        raise(IndexError, "Not Found!")

    if raw:
        permalink = makeRawPermalink(repo=repo, commit=refobj.object.sha, path=path)
    else:
        permalink = makeWebPermalink(repo=repo, commit=refobj.object.sha, path=path)

    return permalink


def read_args():
    parser = argparse.ArgumentParser(description='push files to synapse')
    parser.add_argument('file', help='path to file to upload')
    parser.add_argument('parentId', help="Synapse ID of parent folder")
    parser.add_argument('annotationFile', help="Corresponding annotation file")
    parser.add_argument('provenanceFile', help="Corresponding provenance file")
    parser.add_argument('method', help="name of method used to generate file")
    parser.add_argument('branch', help="branch of metanetworkSynapse we are using")
    parser.add_argument('token', help="GitHub API token")
    parser.add_argument('commitMessage',help="commit message to synapse")
    args = parser.parse_args()
    return (args.file, args.parentId, args.annotationFile,
        args.provenanceFile, args.method, args.branch, args.token, args.commitMessage)

def push(filePath, parentId, annotationFile, provenanceFile, method, branch, token, commitMessage):
    syn = synapseclient.login()
    with open(annotationFile, 'r') as f:
        entries = f.read().strip().split('\n')
        annotations = {s[0] : s[1] for s in [pair.split(',') for pair in entries]}
        annotations['method'] = method
    with open(provenanceFile, 'r') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=',')
        used = [r['provenance'] for r in reader if r['executed'] == 'FALSE']
        executed= [r['provenance'] for r in reader if r['executed'] == 'TRUE']
        g = github.Github(token)
	    #repo = g.get_repo("Sage-Bionetworks/metanetworkSynapse")
	    #config = repo.get_contents("config.sh", ref=branch)
        config = getPermalink(gh=g, repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="config.sh")
	    #thisScript = repo.get_contents("pushToSynapse.py", ref=branch)
        thisScript = getPermalink(gh=g, repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="pushToSynapse.py",raw=False)
        networkScriptName = get_ns_name(method)
        #networkScript = repo.get_contents("networkScripts/%s.sh" % networkScriptName,
	    #ref=branch)
        networkScript = getPermalink(gh=g,repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="networkScripts/%s.sh" % networkScriptName, raw=False)
        if method == "rankConsensus" or method == "bic":
            q = syn.chunkedQuery("select id, name from entity where entity.parentId=='%s'" % parentId)
            [used.append(i['entity.id']) for i in q]
            #submissionScript = repo.get_contents("submissionConsensus.sh", ref=branch)
            submissionScript = getPermalink(gh=g, repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="submissionConsensus.sh",raw=False)
            #pushScript = repo.get_contents("pushConsensus.sh", ref=branch)
            pushScript = getPermalink(gh=g, repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="pushConsensus.sh",raw=False)
            #buildScript = repo.get_contents("buildConsensus.R", ref=branch)
            buildScript = getPermalink(gh=g, repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="buildConsensus.R",raw=False)
        else:
	        #submissionScript = repo.get_contents("submission.sh", ref=branch)
            submissionScript = getPermalink(gh=g, repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="submission.sh",raw=False)
	        #pushScript = repo.get_contents("pushNetworks.sh", ref=branch)
            pushScript = getPermalink(gh=g, repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="pushNetworks.sh",raw=False)
	    if networkScriptName in ['c3net', 'wgcnaTOM', 'mrnet']:
            #buildScript = repo.get_contents("buildOtherNet.R")
            buildScript = getPermalink(gh=g, repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="buildOtherNet.R",raw=False)
	    else:
            #buildScript = repo.get_contents("buildMpiNet.R")
            buildScript = getPermalink(gh=g, repo="Sage-Bionetworks/metanetworkSynapse", ref="master", path="buildMpiNet.R",raw=False)
    executed += [config, networkScript, buildScript, submissionScript, pushScript, thisScript]
    activity = synapseclient.Activity(name='Network Inference', description=method, used=used, executed=executed)
    synFile = synapseclient.File(filePath, parent=parentId)
    synFile.properties['versionComment'] = commitMessage
    synEntity = syn.store(obj=synFile, activity=activity)
    syn.setAnnotations(synEntity, annotations)


def get_ns_name(method):
    if method == "aracne":
	return "mrnet"
    elif method == "wgcnaTopologicalOverlapMatrix" or method == "wgcnaSoftThreshold":
	return "wgcnaTOM"
    elif method == "bic":
	return "rankConsensus"
    else:
	return method

def main():
    filePath, parentId, annotationFile, provenanceFile, method, branch, token, commitMessage = read_args()
    push(filePath, parentId, annotationFile, provenanceFile, method, branch, token, commitMessage)

if __name__ == "__main__":
    main()
