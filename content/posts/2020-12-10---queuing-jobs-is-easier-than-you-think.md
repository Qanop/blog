---
title: Queuing jobs in apps is easier than you think
date: "2020-12-10T00:47:47.000Z"
template: "post"
draft: false
slug: "queuing-jobs-in-apps-is-easier-than-you-think"
category: "Technology"
tags:
  - "Technology"
  - "Dev"
description: "When trying to communicate with our application, we always expect that it is available and can handle our request at a given moment. However, if these things are not certain, or we need to operate in a distributed structure with no known source where the request is to go, we can use task queuing"
socialImage: "media/code-3.jpg"
---
When trying to communicate with our application, we always expect that it is available and can handle our request at a given moment. However, if these things are not certain, or we need to operate in a distributed structure with no known source where the request is to go, we can use task queuing.

![Knowledge books: Python](/media/code-3.jpg)

Queuing is most often used when starting actions that require more processing time and are not required to get immediate results. Therefore, when writing various types of websites, the handling of these orders is triggered in separate processes. The very implementation of the queuing system into your project is also not difficult.

## Producers & Consumers
Queuing uses two modes. In the standard understanding of the process, it is sending a message to a queue created and selected by the user, and the other is reading the stored messages. Messages can be additionally tagged and sorted into appropriate collections working on one queue. Depending on the need to use the queuing server itself, you may want to consider a couple of data sending and reading patterns. This information can be found both in the updates of the tools themselves and in popular forums for developers.

One of the most popular queuing apps & services that are simple to set up and easy to use:
- [RabbitMQ](https://www.rabbitmq.com/)
- [Redis](https://redis.io/topics/pubsub)
- [Kafka](https://kafka.apache.org/)
- [ActiveMQ](http://activemq.apache.org/)
- [ZeroMQ](https://zeromq.org/)
- [Google Cloud Pub / Sub](https://cloud.google.com/pubsub/docs)
- [Amazon Simple Queue Service](https://aws.amazon.com/sqs/)