---
title: Does the beginning of learning programming always have to be boring?
date: "2020-11-09T00:31:12.000Z"
template: "post"
draft: false
slug: "learning-programming-not-always-have-to-be-boring"
category: "Technology"
tags:
- "Technology"
- "Programming"
description: "The beginnings are always difficult, whether when it comes to learning programming or trying to learn a new language. Usually we are looking for a fresh idea to systematically develop it as part of the acquired knowledge. It's hard to find something like this on the internet recently, so I'll share my ideas."
socialImage: "media/notes-2.jpg"
---

The beginnings are always difficult, whether when it comes to learning only programming or trying to learn a new language. Usually we are looking for a fresh idea to systematically develop it as part of the acquired knowledge. It's hard to find something like this on the internet recently, so I'll share my ideas.

The basis of each project is its future development. We can assume that our application, project or script has a chance for development, but also a change of direction. Therefore, the basic project itself must be quite flexible when it comes to introducing changes and allow for the implementation of many improvements and test solutions. This is very important, especially when developing your skills in a free way, where we should have our sandbox at our disposal.

![Finding flexible base project](/media/notes-2.jpg)

The first thing that comes to my mind when it comes to use is building chatbots. By browsing bot repositories for Discord or Telegram, we can discover that there are really thousands of them. Why am I giving this idea first? I once created a bot repository for Telegram as part of a project with friends "Let's write some cool code together". Each person had a different idea, but this did not prevent us from implementing and developing the project. Each of us has evolved while writing code, team findings and understanding some procedures from inside out. Of course, if I come up with another project idea, I'd love to update it here.

## Flexibility
Flexibility is the core of a design. By putting up a bot idea as the first, we can attach a development list to it. I will try to list the possibilities of project development divided into categories from the simplest to the more advanced. Of course, some categories presented may use similar solutions and tools. However, the point of looking at them changes here, and our knowledge, going through the previous points, can significantly improve our work on a more advanced topic. I will use python mentions in the list as now I am in the development stage of the language myself. Each of these solutions can also be used in a different language, and libraries will find alternatives. So no worries, although I think the references may bring some people closer to the subject than just a dry description.

## Bot for Discord / Telegram / Other communicator

#### Read/write data
Possibility to create a list for a channel or for a user. Using commands we can add, subtract or edit items.
So we need to save and later use this data somehow.
- Writing data to a file?
- How to get to them, edit, save?
- Maybe a database? Setting up the entire database server instance or are there any libraries to use local database option?

Alternatively, maybe we can store some record of users who wrote in the chat, make a ranking who was active for how many days, an activity ranking for how many days in a row they were online.

#### Schedule tasks
The ability to run an operation at any time without the need to manually trigger an action. This is a really great option if we need to run some actions recurrently. The basic action could be notification of the collected data since the last time or sending a reminder. The activities for this module may increase with the next steps.
- Are there any libraries to run this kind of functions?

#### Scrapping/fetching + parsing
Let's read an RSS feed and send info about new posts. We just need to know which posts are new and which are already scrapped. The RSS feed can be long, we do not want it to give us a list of all posts every 15 minutes. It would be great if scrapping could work automatically in the background, so there will be no need to run the command manually in the command. RSS feeds are often saved in XML, so you probably need to convert this data from text to some kind of list or dict - somehow program have to read it.

#### Web / API:
After some data saved, we can get to them via API? It's only here, but for Python projects i strongly suggest using Django or fastAPI

#### Test your code
Are you sure your code is 100% working? Are we getting good function results? Will the introduction of a new functionality break another part of the system, do all services communicate? We can answer all these questions by writing tests of our code. Thanks to this, we can rest easy and know that our changes have not damaged the integrity of the code.

#### Documentation
Well-described documentation is more valuable than gold. After some time, you can always come back to function and remember what it did, what arguments it accepted and what it returns. Each language has its own standards, it is worth seeing and applying the description in your project.

#### Advanced scrapping
It's time to get data from real pages. For this, we can always use BeautifulSoup4 and Scrapy for tougher scripted sites
- How we can get information from sites?
- What is the best solution to save data as we know, that every site store them differently?

#### Queuing actions
What if we have a lot of services that outsource a task to be performed? We cannot allow other connections to slow down while waiting for the action to take place. Therefore, the option is to queue tasks and process them in the background in time, when the service itself receives information that a given action has been scheduled. [RabbitMQ](https://www.rabbitmq.com/) is a fairly well-designed and described queuing system that we can start with.

## Tools

#### docker
We don't know what we will encounter in the system, and we know that everyone on the computer has a different language version. It is worth solving with a virtual environment such as docker for both deployment and 24/7 service launch. You can immediately switch to the [docker-compose](https://docs.docker.com/compose/) library - it is more convenient to use, build and configure images.

#### VPS
It is always nice to have your own server if you want to put something to work permanently on it or for simple tests or sandbox. Google gives minimal server configuration [for free](https://cloud.google.com/free/) — it works ok, I even have some services running there. It can handle docker too!

#### git
This tool is must-have! We have to save our projects somehow. I say right away that having _app, app-v2, appv3, app-v3-final, app-v3-final2_ folders does not work (I experienced it). That is why it is worth using repositories and having control over the versions of our code. For this, [GitLab](https://gitlab.com) and [Bitbucket](https://bitbucket.org) give you free private repositories. Git is a necessary thing in the life of a programmer — even in the basics.

## Summary
We must remember, that the most important thing is to try. The code we make is always good if it does what we asked for. It is important to have an initial idea of ​​how to program. After some time, you can go back and improve / rewrite the code. If we see that the old code is ugly, it means that we already have more knowledge than at the beginning. If we feel good at programming, we can move on to new things and knowledge like tests, data structures, good coding practices, communication options, queuing, etc. — There are a lot of topics, but it is worth taking when you feel confident. At the beginning, write the code so that you can do something and develop it with each new idea. Check the data, validate if the user has entered something correctly and so on. Good luck everyone, ever me!