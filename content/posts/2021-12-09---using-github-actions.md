---
title: "Using Github 'actions'" 
date: "2021-12-09T17:47:29.000Z"
template: "post"
draft: false
slug: "using-github-actions"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "When creating pipelines, we often use already-made code we've written ourselves in previous projects. Whether in GitHub Actions we can replace them with maintained actions!"
socialImage: "media/server-11.jpg"
---
When creating pipelines, we often use already-made code we've written ourselves in previous projects. Whether it is CircleCi, BitBucket Pipelines, AWS CodeBuild or GitHub Actions. The problem is when our cloud environment updates and no longer has the old libraries we used.

![Using Github 'actions'](/media/server-11.jpg)

This is what happened to my blog repository. It turns out that every time the LTS version of the NodeJS library is released, it is added to the [GitHub pipelined image](https://github.com/actions/virtual-environments/issues/1953). What caused this? Status failed on my site build pipeline. The solution was to update the packages or lock for the nodejs version. I originally wanted to fix this with another 3 steps in workflow that would allow me to enable the old version of NodeJS (along with `apt-get update` and other commands). The problem is that such steps increase the execution time of the action terribly. Fortunately, it turned out that it was also possible to use the main GitHub Actions feature, the [actions themselves](https://github.com/actions/setup-node). As it turns out, with the use of simple 3 lines, we can be sure that our environment will have the correct version of NodeJS, and changing it is only one parameter.

```yaml
steps:
- uses: actions/checkout@v2
- uses: actions/setup-node@v2
  with:
    node-version: '14'
- run: npm install
- run: npm test
```

The use of template actions is definitely a big advantage of GitHub. It will definitely come in handy for everyone more than once as performing some kind of automation, version lock, testing the environment and much more.