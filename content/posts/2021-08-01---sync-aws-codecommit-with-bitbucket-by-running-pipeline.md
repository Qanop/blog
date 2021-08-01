---
title: Sync AWS CodeCommit with Bitbucket by running pipeline
date: "2021-08-01T23:01:48.000Z"
template: "post"
draft: false
slug: "sync-aws-codecommit-with-bitbucket-by-running-pipeline"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "There is the way to sync our repository to AWS CodeCommit and other services to be later used in private pipelines - without additional app auth's"
socialImage: "media/server-6.jpg"
---
If you don't have access to the official integration of the two apps and their repositories, just do your own sync.

### Set SSH
To prepare your repositories, enable ipelines in your main repository. Then in repository options let Bitbucket create new ssh key, that will be stored in `/opt/atlassian/pipelines/agent/ssh/id_rsa` path.
Try to add generated public key to IAM user AWS CodeCommit keys in Security credentials tab in AWS Console 

### Create config file
Create new config that will be later used in our pipeline with: `nano ~/.ssh/configBitbucket`

```config
Host git-codecommit.*.amazonaws.com
 Hostname git-codecommit.eu-central-1.amazonaws.com
 User YOUR_USER_SSH_KEY
 IdentityFile /opt/atlassian/pipelines/agent/ssh/id_rsa
```
Later try to encode it with: `base64 ~/.ssh/configBitbucket`

### Set Environment Variables
Now with base64 result, use it in Bitbucket Environment Variables

- CodeCommitConfig: OUR_BASE64_CONFIG
- CodeCommitHost: git-codecommit.aws-region.amazonaws.com
- CodeCommitRepository: git-codecommit.aws-region.amazonaws.com/v1/repos/sample
- CodeCommitUser: SSH_USER_PUBLIC_KEY

### Create Pipeline Step

Provided env's will be used in pipeline step below

```yaml
definitions: 
  steps:
    - step: &sync-codecommit
        name: Sync changes to CodeCommit
        script:
          - echo $CodeCommitConfig > ~/.ssh/config.tmp
          - base64 -d  ~/.ssh/config.tmp > ~/.ssh/config
          - cat ~/.ssh/config
          - set +e
          - ssh -o StrictHostKeyChecking=no $CodeCommitHost
          - set -e
          - git remote add codecommit ssh://$CodeCommitRepository
          - git push codecommit $BITBUCKET_BRANCH --force

pipelines:
  default:
    - step: *sync-codecommit
```

Now, whenever you push to Bitbucket, it will also push to CodeCommit. For more details and better step by step configuration you can check also this [Medium post](https://medium.com/@wooltar/aws-codecommit-push-from-bitbucket-pipeline-2f5e08fe3629)