#metanetworkSynapse

## Cluster Setup

`remote.sh` is written to be run on the master node of a cluster running a custom image of CentOS6 [here](https://github.com/Sage-Bionetworks/CommonCompute).

After building the machine image and pushing to AWS, spin up a cluster using the AMI.

## Basic Usage
To generate networks for dataset `abcd`, run the following commands on your localhost (this requires a `.synapseConfig` file in your home [~] directory for pushing the networks to Synapse from the master node):

```
git clone -b abcd https://github.com/philerooski/metanetworkSynapse.git
cd metanetworkSynapse
sh localhost.sh /path/to/private/key.pem your.master.nodes.public.DNS
```

i.e., the call to localhost.sh might look like `sh localhost.sh ~/.aws/myKey.pem ec2-52-55-94-233.compute-1.amazonaws.com` if you have a cluster running in the AWS cloud.

This will install all dependencies in `/shared` on your cluster and submit the network jobs to the SGE queue. Networks built via the `submission.sh` call are high CPU intensive and medium memory intensive jobs. Be sure you have enough cores among your compute nodes to run the most demanding jobs (# compute nodes * # CPU per compute node >= `nthreadsHeavy` in `submission.sh`).

Once the jobs are finished running, if you wish to push the networks to Synapse you must: 

* Log into your master node. 
* Edit `/shared/metanetworkSynapse/config.sh` so that `parentId` points to a Folder on Synapse that you have write permission for.
* Call `sh pushNetworks.sh [gitUsername] [gitPassword]`. Passing in your username and password for Git isn't necessary, but allows `pushToSynapse.py` to authenticate its requests to GitHub when building the Provenance for each network. Very few unauthenticated requests are allowed per time period. If you don't wish to authenticate, you may need to run `pushNetworks.sh` twice to push all the networks to Synapse.

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
