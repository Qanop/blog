---
title: Installing Lutris on Debian from A to Z
date: "2021-10-16T08:32:54.000Z"
template: "post"
draft: false
slug: "installing-lutris-on-debian-from-a-to-z"
category: "Technology"
tags:
  - "Technology"
description: "After Nth attempt I finally managed to install fully working Lustris on Debian. There were some ups and downs during the installation, but finally I was able to get a fully working Wine with VulcanAPI support."
socialImage: "media/server-9.jpg"
---
After Nth attempt I finally managed to install fully working Lustris on Debian. There were some ups and downs during the installation, but finally I was able to get a fully working Wine with VulcanAPI support.

![Installing Lutris on Debian from A to Z](/media/server-9.jpg)

First, time to introduce my old but strong potato machine. It's durable (hole in the wall confirm it) ThinkPad T450s. So... It's components are not great and not terrible - i5-5300U with Intel HD 5500. And that added me additional problems to the list. As you can see, Vulcan have only [partial support](https://software.intel.com/content/www/us/en/develop/blogs/new-intel-vulkan-beta-1540204404-graphics-driver-for-windows-78110-1540.html) for older CPU Intel generations, so it could cause problems if you are not aware off different installation of dxvk library. For basic installation of dxvk on Debian with only Intel graphics you can follow [mesa driver guide](https://github.com/doitsujin/dxvk/releases) that is required also [by the Lutris](https://github.com/lutris/docs/blob/master/InstallingDrivers.md).

When installing Lutris, be aware, that you need ALL required components of Wine! Even when Lustris manage to download its own Wine libs, it's still using some system libraries. That's why you should follow fully [Wine Dependencies guide](https://github.com/lutris/docs/blob/master/WineDependencies.md). 

As I mention before, I had problem with Debian installation of Wine on my laptop. Main problem was caused by wrongly committed version to debian repository - and it's common problem for past few months in Wine community...
```shell
sudo apt-get install --install-recommends winehq-staging

The following packages have unmet dependencies:
 winehq-staging : Depends: wine-staging (= 6.17~focal-1)
E: Unable to correct problems, you have held broken packages.
```
To 'fix' it, just enter to download site of Wine, and download and install [winehq-staging .deb](https://dl.winehq.org/wine-builds/debian/dists/buster/main/binary-amd64/) package manually. Causing problem could occur by missing libfaudio0 library, which could not be installed with package manager... But thanks to [this post](https://askubuntu.com/questions/1145473/how-do-i-install-libfaudio0) on Ubuntu forum, I found [open repository](https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/) containing right library package.

After this, I finally could play my games running on DirectX 9 (But translated in air by Vulcan, which give additional 50% boost). So yea, game was pretty much playable with stable 20 fps (and with later expansion 17fps), on the lowest settings - but I didn't expect much, and I was glad that it could ever work on this device. But I have one conclusion - If you want a Linux distro for gaming proposes, you should install Ubuntu or Pop!OS... It's easier to set up.