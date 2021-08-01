---
title: Detailed description of your API
date: "2020-11-06T22:38:31.000Z"
template: "post"
draft: false
slug: "detailed-description-of-your-api"
category: "Technology"
tags:
  - "Technology"
  - "Dev"
description: "A good described API is attitude. Especially when planning architecture, where other teams work on its successive elements. Therefore, it is so important to describe in detail each API path. For this, it is worth using the right tool."
socialImage: "media/server-5.jpg"
---
A good described API is attitude. Especially when planning architecture, where other teams work on its successive elements. Therefore, it is so important to describe in detail each API path. For this, it is worth using the right tool.
With a growing team, you need to be aware that communication between people must be at the highest level. To do this, it is often interfered with the introduction of many management tools. With such activities, you should also remember about the list of documentation and knowledge sharing. [Swagger](swagger.io) is one of such tool to help share information between developers about API endpoints in the project.

![Functions of Swagger](/media/server-5.jpg)

This tool is most often found in the form of various libraries for automatic building of API documentation from the current project code. Sure, this is one of the possibilities of this project, but often people overlook the standard operation of the main tool itself. For their integration, libraries ignore many additional functionalities provided by the basic swagger tool. Also, such libraries often may not allow for some kind of adding comments or define some kind of elements as additional or existing under some specific logic. Another thing is the modification of documentation that is scattered all over the code. Therefore, it is worth taking a look at the basic operation of the Swagger Editor itself.

## Swagger Editor
The approach to Swagger can be difficult, but I encourage you to check what a well-structured endpoint description for a specific module or the entire project may look like. The example that can be found in the [Swagger Editor](https://editor.swagger.io/) tool describes all the cases encountered during the API description. As I can say editor allows to do a better description of the default fields, which this option from my experience is rarely found in integrated libraries. In addition, we can also download the desktop app beside web and cloud versions.

## Summary
Generating the final documentation and forwarding it to the next department, which can be a frontend, for example, can be a great advantage for the implementation of the project. It also solves many questions whether and what the API data returns, reduces the number of tests, speeds up the project structure and may also allow for better planning of the API before writing it. The tool and the JSON file itself or the full output should become an integral part of any larger project.