---
title: Why dockerizing production isn't bad idea
date: "2020-11-24T19:39:40.000Z"
template: "post"
draft: false
slug: "why-dockerizing-production-isnt-bad-idea"
category: "Technology"
tags:
- "Technology"
- "Ops / DevOps"
description: "The use of docker is a common technique in dev teams. But really, creating and using the complete ready-made image shows its potential in the production environment. I think this post will convince some Ops to look more positively at running closed images over the installation and putting projects directly on the servers"
socialImage: "media/server-6.jpg"
---
The use of docker is a common technique in dev teams. But really, creating and using the complete ready-made image shows its potential in the production environment. I think this post will convince some Ops people to look more positively at running closed images over the installation and putting projects directly on the servers.

There are many benefits to using images. For the development of the application, its tests, and automation, up to a running product. Along with the development of the industry, there were also many new technologies enabling the management of more servers as part of the application publishing itself. Some of them were designed directly by the current cloud operators. The emergence of a new branch of technology also forced the creation of a new profession - DevOps.

![Birth of DevOps](/media/server-6.jpg)

Each team looks for Docker and its derivative benefits in terms of work efficiency and simplification of the tasks assigned to them. Therefore, to better understand each of the teams and their point of view, each has its chapter. This will allow you to understand the possibility of using this technology in every step of the project.

## Dev
Creating docker images while developing an application is currently one of the requirements in the hiring process. This is more or less because previously programmers had to build up their programming environment. Knowledge of Linux was a standard in the job description ever to know how to install the appropriate version of packages for the operation of their project. Unfortunately, the problem of installing main packages by programmers grew when they started working on several projects at the same time in different global package versions. Unfortunately, switching between versions was not convenient, it often required additional configuration files, and sometimes it forced to re-install them. Virtualization came to the rescue, which separated each project and did not require having specific versions of packages on the user's main system. Due to the [hardware consumption and number of layers](https://geekflare.com/docker-vs-virtual-machine/) in virtualization technology, Docker is the most used today.
The development team needs to use application images because the same versions of the libraries are used on each workstation. To make editing the project code comfortable, it is common practice to link the folder with the code from the user's machine to the running image. This operation makes the environment clean enough to allow the project to be built from scratch as if it were in a regular non-image environment. This allows for the utmost control over the project.

## DevOps
This position is mostly related to the CI/CD function. The absolute automation of the application release process, updating images for security reasons, and control of application communication is what characterizes this work. With more projects to look after, the job requires a lot of management procedures. Recently, due to the growing interest among others in [Kubernetes](https://kubernetes.io/), DevOps is more and more often dealing with new tools offered by operators like Google Cloud or AWS.
The arrangement of procedures in this profession is very important. Thanks to this, work with applications can be automated and images properly prepared. These people look after the internal environment of the application, test performance, check application statistics, and try to improve every point of it. The variation of tools for DevOps is huge, and they are often mixed - library changes can be compared to the same dynamically changing frontend technology. The Best description? One command should execute and handle each exception. Obtaining total automation in a project is the greatest reward.

## Ops
The main task of this team is to create a safe system. Protection of any undesirable entrances, provision of external services, and monitoring the SLA of servers. Due to the profile of this profession, it is heavily responsible for data access and security. Increasingly, companies are moving away from burdening this team with app releases (due to the possibility of unexpected errors during updates, restoring the previous version, and consulting with the development team). Since these activities were a shared responsibility of the teams and usually required additional access for other departments, this function is postponed for safety. Instead, these actions are now being replaced with images of the application. The difference between the old and the new way can be broken down into points.

Classic prod environment update (application downtime):
- blocking access to the application as part of updating the environment
- [optional] software update to support new functionalities (~ 10 min)
- updating application libraries (~ 5min)
- [optional] migrations in the database (~ 5min)
- unblocking access and admitting users
- negative path
- restoring the old code version (~ 1 min)
- restoration of the old software version (if the functions were deprecated) (~ 10 min)
- installation of application libraries (~ 5 min)

Updating the prod environment using Docker tools (application downtime):
- download an image with the code included
- replacing the version of the prepared image and restarting the configuration
- blocking access to the application as part of updating the environment
- docker facilitates this by using load balancing, which makes this point optimal
- in the image, you can add code that will do some tasks before starting the motion in the application
- [optional] database migrations (~ 2-5min)
- when starting the image, check if you should perform the migration, if not - continue
- negative path
- run old version of the image (~ 1 min)

Seeing the steps given, you can see that preparing an image with built libraries, a good version of the software, and included code is a big profit. By adding release automation and even server conversion to a [Kubernetes cluster](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/), we simplify the issue of publishing drastically. Images created by teams are closed by default and it is up to us how we make them available to the world - or the environment configuration team will take care of it. By receiving such a simplification, people responsible for security and services can focus on their tickets and improving their work.