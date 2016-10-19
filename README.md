#metanetworkSynapse

## Cluster Setup

`remote.sh` is written to be run on the master node of a cluster running a custom image of CentOS6 [here](https://github.com/Sage-Bionetworks/CommonCompute).

After building the machine image and pushing to AWS, spin up a cluster using the AMI.

metanetworkSynapse requires the `openmpi-x86_64` module on the cluster.

## Basic Usage
To generate networks using the expression matrix located at syn1234567, first edit `config.sh` so that `dataSynId = syn1234567`, then run the localhost script (this suggests, but does not require, a `.synapseConfig` file in your home [`~`] directory for pushing the networks to Synapse from the master node):

```
sh metanetworkSynapse/localhost.sh /path/to/private/key.pem your.master.nodes.public.DNS https://github.com/a/version/of/metanetworkSynapse.git
```

i.e., the call to localhost.sh might look like `sh localhost.sh ~/.aws/myKey.pem ec2-52-55-94-233.compute-1.amazonaws.com https://github.com/blogsdon/metanetworkSynapse.git` if you have a cluster running in the AWS cloud and want to use the original metanetworkSynapse repository.

`https://github.com/a/version/of/metanetworkSynapse.git` is the fork, branch, etc. of metanetworkSynapse you would like to run on the cluster. Your local copy of `config.sh` will be copied over the preexisting `config.sh` in that repository on the master node.

This will install all dependencies in `/shared/` on your cluster and submit the network jobs to the SGE queue. Networks built via the `submission.sh` call are high CPU intensive and medium memory intensive jobs. Be sure you have enough cores among your compute nodes to run the most demanding jobs (# compute nodes * # CPU per compute node >= `nthreadsHeavy` in `submission.sh`).

Once the jobs are finished running, if you wish to push the networks to Synapse you must: 

* Log into your master node. 
* Edit `/shared/metanetworkSynapse/config.sh` so that `parentId` points to a Folder on Synapse that you have write permission for.
* Call `sh pushNetworks.sh [githubAPIToken]`. The token needs the `public_repo` scope, which gives you the ability to access public repositories.

Once the regular networks have been pushed to Synapse, we can build the rank consensus network.

```
sh submissionConsensus.sh
```

Building the rank consensus network is a low CPU intensive and high memory intensive job. I recommend using an instance with at least 50 times as much RAM as the size of the largest network generated via `submission.sh`. 

Once the job submitted by `submissionConsensus.sh` finishes, we can push the rank consensus network to Synapse with `sh pushConsensus.sh`.

## Advanced Usage

### Troubleshooting

When running jobs, error and output logs are kept in `/shared/network/errorLogs/` and `/shared/network/outLogs/`, respectively.

If there are other problems submitting jobs to the SGE queue, building the networks, or pushing to Synapse, we provide a small test network for debugging. The process for running the test network is the same as above, except the main configuration file is kept in `configTest.sh`, jobs are submitted with `sh submissionTest.sh`, completed networks are pushed to Synapse with `sh pushTest.sh`, and the rank consensus network is built with `sh submissionTestConsensus.sh`. Error and output logs for the test network are in `/shared/testNetwork/errorLogs/` and `/shared/testNetwork/outLogs/`, respectively.
