---
title: "Secure files using git-crypt" 
date: "2021-12-20T23:50:13.000Z"
template: "post"
draft: false
slug: "secure-files-using-git-crypt"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "With the use of git-crypt, we can secure sensitive data, keys or passwords without separating them outside the repository"
socialImage: "media/server-2.jpg"
---
There is one major problem when working on a public repository. Anyone can see our access data in our project. It is impossible to hide, at some point, the project may lack another layer securing the data, or even a simple `.env` file with the data required by the project.

[Git-crypt](https://www.agwa.name/projects/git-crypt/) comes in handy, in which we can encrypt and decrypt files automatically and upload them to the repository with each commit. Each user requires registration and entering their GPG key into the repository. People who do not have the key will not be able to decode the content of the file.

Configuration which files we want to encrypt:
```
secretfile filter=git-crypt diff=git-crypt
*.key filter=git-crypt diff=git-crypt
secretdir/** filter=git-crypt diff=git-crypt
```

Initialization and unlocking of the repository:
```shell
git-crypt init
git-crypt add-gpg-user USER_ID
git-crypt unlock
```
