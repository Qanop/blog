---
title: GitFlow & Versioning
date: "2021-07-01T20:41:32.000Z"
template: "post"
draft: false
slug: "gitflow-and-versioning"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "Trying to keep the branch in order, we can use the GitFlow formula and adjust our tactics for future product releases. Each version and its important aspect has its own initials and ever additional values as release candidates"
socialImage: "media/server-1.jpg"
---
Trying to keep the branch in order, we can use the GitFlow formula and adjust our tactics for future product releases. Each version and its important aspect has its own initials and ever additional values as release candidates. In addition, the tagging system and its automation ensure the integrity of project tags even in the event of unwanted but often used hotfixes of the main branch.

![Merge strategies](/media/gitflow-and-versioning/gitflow-branches.png)

The defined version is especially needed when releasing the application issuing the API because specifying this source can tell us about possible fixed things, new functionalities, or a new version incompatible with the previous one.

To be sure what version our code change should be, we can keep an additional changelog [CHANGELOG.md](https://keepachangelog.com/en/1.0.0/) which will help people find out what things are currently in the branch to be released and what things have been changed/fixed/added in recent commits

- [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html)
- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## Tags Automation
The script below can be a nice help as it downloads the latest tags and then adds new ones as requested by the user. It is suggested to create and post tags on the target branch

```makefile
#--------------------------------- Git ----------------------------------------------------#
GIT_LAST_TAG = $(lastword $(shell git tag --sort=taggerdate))
GIT_VERSION := $(subst -RC, , $(subst v,, $(subst ., ,$(GIT_LAST_TAG))))
GIT_MAJOR := $(word 1, $(GIT_VERSION))
GIT_MINOR := $(word 2, $(GIT_VERSION))
GIT_PATCH := $(word 3, $(GIT_VERSION))
GIT_RC := $(word 4, $(GIT_VERSION))
#--------------------------------- Git ----------------------------------------------------#

tag-major:
ifeq ($(GIT_RC),)
	$(eval tag = v$(shell echo $(GIT_MAJOR) + 1 | bc).0.0)
else
	$(eval tag = v$(GIT_MAJOR).0.0)
endif
	git tag $(tag) -m $(tag)

tag-major-rc:
ifeq ($(GIT_RC),)
	$(eval tag = v$(shell echo $(GIT_MAJOR) + 1 | bc).0.0-RC1)
else
	$(eval tag = v$(GIT_MAJOR).0.0-RC$(shell echo $(GIT_RC) + 1 | bc))
endif
	git tag $(tag) -m $(tag)

tag-minor:
ifeq ($(GIT_RC),)
	$(eval tag = v$(GIT_MAJOR).$(shell echo $(GIT_MINOR) + 1 | bc).0)
else
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).0)
endif
	git tag $(tag) -m $(tag)

tag-minor-rc:
ifeq ($(GIT_RC),)
	$(eval tag = v$(GIT_MAJOR).$(shell echo $(GIT_MINOR) + 1 | bc).0-RC1)
else
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).0-RC$(shell echo $(GIT_RC) + 1 | bc))
endif
	git tag $(tag) -m $(tag)

tag-patch:
ifeq ($(GIT_RC),)
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(shell echo $(GIT_PATCH) + 1 | bc))
else
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(GIT_PATCH))
endifgit tag $(tag) -m $(tag)

tag-patch-rc:
ifeq ($(GIT_RC),)
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(shell echo $(GIT_PATCH) + 1 | bc)-RC1)
else
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(GIT_PATCH)-RC$(shell echo $(GIT_RC) + 1 | bc))
endif
	git tag $(tag) -m $(tag)
	git tag $(tag) -m $(tag)

tag-patch-rc:
ifeq ($(GIT_RC),)
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(shell echo $(GIT_PATCH) + 1 | bc)-RC1)
else
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(GIT_PATCH)-RC$(shell echo $(GIT_RC) + 1 | bc))
endif
	git tag $(tag) -m $(tag)
```

## Docker Images Versioning
When it comes to updating the version with Docker images, the best example is checking libraries that customers do not necessarily want to have in the latest version. One example is the [python image](https://hub.docker.com/_/python).

When we look at the image side, we see a description of the shared, simplified, and individual tags. What's the difference and what version is best to put in our Dockerfile?

Let's assume that our project is currently using the newest python version `3.7.4`. If we want the latest updates from the code side, we have several options. Downloading `latest`, `3`, and `3.8` tags. Depending on how often we will update the code, we want to protect ourselves against possible "code deprecation" that may occur in future versions. narrowing down the tag versions to download specific trees can prevent us from getting the latest changes in the library, but also protect us against possible old functionalities removed (and even against changing to the full version of the library after a few years)

Therefore, it can be said that the safest version for the production environment is setting tags targeting patches (like `python:3.8`), and the development version for the minor or even major version (like `python:3` or ever `python:latest`) - due to the possibility of testing even the expected changes in the used library, which can then be safely updated in production