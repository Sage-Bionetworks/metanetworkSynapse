import synapseclient
import argparse
import github
import csv

def read_args():
    parser = argparse.ArgumentParser(description='push files to synapse')
    parser.add_argument('file', help='path to file to upload')
    parser.add_argument('parentId', help="Synapse ID of parent folder")
    parser.add_argument('annotationFile', help="Corresponding annotation file")
    parser.add_argument('provenanceFile', help="Corresponding provenance file")
    parser.add_argument('method', help="name of method used to generate file")
    parser.add_argument('branch', help="branch of metanetworkSynapse we are using")
    parser.add_argument('gitUsername', help="Github username")
    parser.add_argument('gitPassword', help="Github password")
    args = parser.parse_args()
    return (args.file, args.parentId, args.annotationFile, \
        args.provenanceFile, args.method, args.branch, \
	args.gitUsername, args.gitPassword)

def push(filePath, parentId, annotationFile, provenanceFile, method, branch, gitUsername, gitPassword):
    syn = synapseclient.login()
    with open(annotationFile, 'r') as f:
        entries = f.read().strip().split('\n')
        annotations = {s[0] : s[1] for s in [pair.split(',') for pair in entries]}
        annotations['method'] = method
    with open(provenanceFile, 'r') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=',')
        used = [r['provenance'] for r in reader if r['executed'] == 'FALSE']
        executed= [r['provenance'] for r in reader if r['executed'] == 'TRUE']
        g = github.Github(gitUsername, gitPassword) if (gitUsername and gitPassword) \
		else github.Github()
	repo = g.get_repo("philerooski/metanetworkSynapse")
	config = repo.get_contents("config.sh", ref=branch)
	thisScript = repo.get_contents("pushToSynapse.py", ref=branch)
	networkScriptName = get_ns_name(method)
        networkScript = repo.get_contents("networkScripts/%s.sh" % networkScriptName, 
	    ref=branch)
        if method == "rankConsensus" or method == "bic":
	    q = syn.chunkedQuery("select id, name from entity \
		where entity.parentId=='%s'" % parentId)
            [used.append(i['entity.id']) for i in q]
	    submissionScript = repo.get_contents("submissionConsensus.sh", ref=branch)
            pushScript = repo.get_contents("pushConsensus.sh", ref=branch)
            buildScript = repo.get_contents("buildConsensus.R", ref=branch)
        else:
	    submissionScript = repo.get_contents("submission.sh", ref=branch)
	    pushScript = repo.get_contents("pushNetworks.sh", ref=branch)
	    if networkScriptName in ['c3net', 'wgcnaTOM', 'mrnet']:
	        buildScript = repo.get_contents("buildOtherNet.R")
	    else:
		buildScript = repo.get_contents("buildMpiNet.R")
    executed += [config.html_url, networkScript.html_url, buildScript.html_url, 
	submissionScript.html_url, pushScript.html_url, thisScript.html_url]
    activity = synapseclient.Activity(name='Network Inference',
            description=method, used=used, executed=executed)
    synFile = synapseclient.File(filePath, parent=parentId)
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
    filePath, parentId, annotationFile, provenanceFile, method, \
	branch, gitUsername, gitPassword = read_args()
    push(filePath, parentId, annotationFile, provenanceFile, method,
	branch, gitUsername, gitPassword)

if __name__ == "__main__":
    main()
