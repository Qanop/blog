---
title: Media library with 2TB cloud storage on VPS
date: "2020-10-31T13:50:26.000Z"
template: "post"
draft: false
slug: "vps-with-2tb-cloud-storage"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "A lot of people have a collection of movies or photos that they would like to share with friends. Installing Netflix imitation services is good, but requires a really large amount of costly space on the VPS servers. Of course, there is a solution for that"
socialImage: "media/movie.jpg"
---
I have to admit, having your own private Netflix-like service is really nice.

The project I have had contact with recently is Jellyfin. It is a very welcoming and multi-device media software system. The project, as in the case of kodi, allows you to manage the media library, download and complete information about the downloaded content, it has an automatic season organizer for TV Shows and allows you to watch Live TV & DVR and more. All this is available under the www panel placed on our home server or VPS. For all devices and access from everywhere.

## Data storage problem
Ever if you install media center on the server and want to store a collection of movies to watch, you usually don’t have much disk space. It is understandable, because we do not attach large NAS drives or other heavy devices to each of our servers.

Unfortunately, for VPS servers, the matter of renting additional space becomes even more complicated Therefore, before approaching the topic, you should consider what problems you may encounter when accessing and reading/writing multimedia from the server.

![Solutions for own media center](/media/movie.jpg)

#### Home server
The first solution is to have your own home server. However, this requires an investment in an additional large external drive, and the design itself does not look so nice. Of course, for most people, the very result of the work will be important. Such a server will have a problem with exposing the service to the world, but you can connect to it using DDNS or VPN service — which unfortunately makes the availability of the device difficult if we are away from home. Another disadvantage is the amount of session maintenance and usage of CPU for video encoding. It may turn out that it will not be possible to support more than two users at the same time. If these drawbacks are not that important to someone, you can always use this solution.

#### VPS
Purchasing a private server from the service provider will allow us to obtain more resources to use. It is also a good alternative, because we do not have to worry about access, and we know that the server itself is protected against failures. The only problem is usable space, which often ends with the offered 20 GB SSD.

#### Cloud Storage
There are a couple of options to get around this limit. The first one is to buy storage from the server provider itself. Unfortunately, this is probably the most expensive option. The second option is to purchase services for blop files. It works on the basis of file transfer in the form of file fragmentation of 20 MB. One such service is [Wasabi](https://wasabi.com/), a good alternative to enlarge the server disk cheaper than Amazon S3, with no API or egress fees. If someone would like to test this service, there should still be a option for a first month free. The third option is to use a regular private cloud for data synchronization. This is quite an interesting option, but you have to read which clouds will be useful for use on the server. Private clouds have two modes, the first is to copy physical files 1:1, the second is to send files to the cloud and access them on demand, and we treat the file structure as links. For low capacity servers use the second option. After checking out the cloud offerings, I found that Dropbox was the easiest one (there are other service providers, of course). If you have an account with likely 2 TB of cloud data, it is good to connect it to one of the folders on the server. For known cloud services, it is strongly suggested using the [rclone](https://rclone.org/) program for simple authorization on linux systems. In addition, it has the option of data encryption and decryption, so only people with the key will be able to see the real content of the cloud. After such an operation, our server with large capacity for data storage will be ready.

## Summary
The last step is to install [Jellyfin](https://jellyfin.org/) mentioned at the very beginning of post and select the folder of stored movie libraries. I also suggest installing an FTP server for easier file transfer to the server. Consequently, if someone is more advanced in console server operation, [rsync](https://linux.die.net/man/1/rsync) is a good alternative. With such activities, what is left is to create an account, send files and enjoy the new private media service. I have been using the current solution for six months now and I must admit that I do not feel the need to switch to another platform. It is also especially good if several people work on one such website. Then it's easier to find something new to watch and share your insights.