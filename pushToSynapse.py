import synapseclient
import argparse
import csv

def read_args():
    parser = argparse.ArgumentParser(description='push files to synapse')
    parser.add_argument('file', help='path to file to upload')
    parser.add_argument('parentId', help="Synapse ID of parent folder")
    parser.add_argument('annotationFile', help="Corresponding annotation file")
    parser.add_argument('provenanceFile', help="Corresponding provenance file")
    parser.add_argument('method', help="name of method used to generate file")
    args = parser.parse_args()
    return args.file, args.parentId, args.annotationFile, args.provenanceFile, args.method

def push(filePath, parentId, annotationFile, provenanceFile, method):
    syn = synapseclient.login()
    with open(annotationFile, 'a') as f:
        f.write('method %s' % method)
    with open(provenanceFile, 'r') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=',')
        used = [r['provenance'] for r in reader if r['executed'] == 'FALSE']
        executed= [r['provenance'] for r in reader if r['executed'] == 'TRUE']
    activity = synapseclient.Activity(name='Network Inference', 
            description=method, used=used, executed=executed)
    synFile = synapseclient.File(filePath, parent=parentId)
    syn.store(obj=synFile, activity=activity)

def main():
    filePath, parentId, annotationFile, provenanceFile, method = read_args()
    push(filePath, parentId, annotationFile, provenanceFile, method)

if __name__ == "__main__":
    main()
