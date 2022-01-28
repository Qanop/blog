---
title: "Building ad-block home server from the scratch. Again..."
date: "2022-01-28T22:58:33.000Z"
template: "post"
draft: false
slug: "building-rpi-from-the-scratch"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "After the recent chaos I found on my Raspberry Pi server and its unstable performance I made a fresh attempt to build a simple ad filter in my home using rPi"
socialImage: "media/server-4.jpg"
---
After the recent chaos I found on my Raspberry Pi server and its unstable performance I made a fresh attempt to build a simple ad filter in my home using rPi.

First, remember to change default password of `pi` user!
```shell
sudo raspi-config
```

Install PiHole from official script, set/reset password for web admin and add auto-update PiHole line to crontab
```shell
curl -sSL https://install.pi-hole.net | bash
pihole -a -p

crontab -e
# 0 5 * * * pihole -up
```

I have to admit that PiHole's basic blacklists do a good job of filtering ads, but there are places on the web that require more url restriction (like scammer sites). I previously used firebog list for this and manually tried to add lists of blocked sites to the tool. However, as it turns out, someone smart has added their [python script](https://github.com/jessedp/pihole5-list-tool) to automatically add the appropriate list option from both [firebog](https://firebog.net/) (blacklist) and/or [anudeepND/whitelist](https://github.com/anudeepND/whitelist) (whitelist).

Also consider adding blocklists focused on your home smart devices:
- [Xiaomi DNS blocklist](https://github.com/unknownFalleN/xiaomi-dns-blocklist)

```shell
sudo pip3 install pihole5-list-tool --upgrade
pihole5-list-tool

#     ┌──────────────────────────────────────────┐
#     │       π-hole 5 list tool  v0.6.0         │
#     └──────────────────────────────────────────┘
#     https://github.com/jessedp/pihole5-list-tool
# 
# ! docker not found running, continuing...
# 
# ? Gravity Db to Update:  /etc/pihole/gravity.db
# 
#   Blocks Enabled:  All=0   │   Ours=0   │   Allows Enabled:  All=0   │   Ours=0 
# 
# ? Options:  Manage Blocklists
# ? Blocklist action:  Add a list
# ? Where are the block lists coming from?  Firebog | Non-crossed lists : Use when someone is usually around to allow
# 
#     Do not hit ENTER or Y if a step seems to hang!
#     Use CTRL+C if you're sure it's hung and report it.
#     
# ? Add 45 block lists?  Yes
# 45 block lists added! 0 already existed.
#   Ad/Blocklist Stats   │  Top 3 by Comment                          
# ───────────────────────┼────────────────────────────────────────────
#    Total     :  45/45  │   Firebog | Non-crossed lists [ph5lt]  45  
#    Our Lists :  45/45  │                                            
#    Others    :  0/0    │                                            
#                        │                                            
# ? Are you finished?  Yes
# ? Update Gravity for immediate effect?  Yes
```

The final step is to auto-update the rPi itself. I wanted to use a standard crontab with the update+upgrade command to do this, but the problem here may be the occurrence of a dialog windows. A better solution to avoid this problem and update your rPi server with security payloads is to use the [UnattendedUpgrades library](https://wiki.debian.org/UnattendedUpgrades) 
```shell
apt-get install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

This is the most basic server setup, which should take no more than 30min. But it is also a good basis for future activities with the system that is currently set up and running smoothly. In the future, if I add something as a "base image" for the home server, I will add additional commands in the end of this post.