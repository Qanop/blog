---
title: Your own VPN service in USA
date: "2020-11-01T21:37:05.000Z"
template: "post"
draft: false
slug: "your_own_vpn_service_in_usa"
category: "Technology"
tags:
  - "Server"
description: "Regional locks aren't fun. They always cause a problem with access to certain sources. VPN service charges are often high, and the free versions only offer a certain usage limit or are bandwidth-constrained. Therefore, why not set up your own free VPN server overseas?"
socialImage: "media/server-1.jpg"
---
Regional locks aren't nice. They always cause a problem with access to certain sources. VPN service charges are often high, and the free versions only offer a certain usage limit or are bandwidth-constrained. Therefore, why not set up your own free VPN server overseas?

## Virtal Private Server
There are a lot of VPS offers on the Internet. This time the search is directed a bit differently than the access and HTTP servers. The first thing we need to pay attention to is where the service is run, and then what is the suggested rental price of the resources. From large suppliers, we may be interested in well-known service providers such as OVH, AWS, Azure or Google. They can often have strong server rental deals or special free-tier offers. However, be careful whether the server will not be refunded after the end of the promotional period.

![Solutions for own media center](/media/server-1.jpg)

In paid offers from service providers you can find very cheap servers listed below

- Vultr: Worldwide locations, IPv6 support, starting at $3.50/month
- Hetzner: Germany, IPv6, 20 TB of traffic, starting at €3/month
- Digital Ocean: Worldwide locations, IPv6 support, starting at $5/month
- PulseHeberg: France, unlimited bandwidth, starting at €3/month
- OVH: Worldwide locations, IPv6 support, starting at $3.50/month

Currently, the most attractive offer, in my opinion, can boast of google cloud, which offers a [full free-tier](https://cloud.google.com/free) for a machine located in Oregon, Iowa or South Carolina.

## Free-tier in Google Cloud Platform
Basic server configuration starts with creating a [Compute Engine](https://console.cloud.google.com/compute) instance. When creating it, we must remember about the appropriate region — although here the choice is more about continents. The instance that interests us is F1-micro, which will be enough for us to provide this and several other services.
The next step will be to connect to the server via SSH and install OpenVPN. Unfortunately, for first-time users, installing OpenVPN can be a bit complicated. Large descriptions of functions in the documentation, no direct support for some distributions, configuration of files without full understanding. Unfortunately, this is not the simplest solution. Therefore, for users who do not want to play with the configuration of the server to support the entire company, but only for private purposes, very nice repositories have been created to auto-install this service.

- [Simplest instalation](https://github.com/Nyr/openvpn-install)
- [If someone want more controll over configs](https://github.com/angristan/openvpn-install)

After installation, all you need to remember is editing firewall rules to allow incoming traffic from another port. For GCP, we can find it at [this link](https://backports.debian.org/Instructions/). It is suggested to add a new rule, assign the VPN ports, add a tag to the Compute Engine instance and reset the system to accept all changes.

## Summary
If someone can install servers quickly or has their VPS abroad, this is a perfect opportunity to have a VPN for streaming services. Thanks to this, we will be able to use the advantages of service providers such as NordVPN or ExpressVPN without the need to buy a subscription or free providers with trial access and shady data usage. In addition, the data that passes through the server is ours, so there is less risk of it being viewed by an unknown person from an unknown proxy server.