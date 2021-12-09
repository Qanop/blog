---
title: "Launch multiple WordPress server in docker way" 
date: "2021-11-21T19:23:17.000Z"
template: "post"
draft: false
slug: "launch-multiple-wordpress-server-in-docker-way"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: "If you want to run multiple WordPress sites and other services but don't have time to configure each one with their specific library versions, you can set all in one big docker config"
socialImage: "media/server-1.jpg"
---
If you want to run multiple WordPress sites and other services but don't have time to configure each one with their specific library versions, you can set all in one big docker config. To run this all, you'll need an app image itself, reverse proxy preferably with SSL automation and in most cases' database.

![Launch multiple WordPress server in docker way](/media/server-1.jpg)

Example below should launch multiple instances of sites, configure them to connect to local database running on host machine, allow reverse-proxy and maintain SSL certificates. 

```yaml
version: '3'
services:

  #  -----------------------------------------------
  #  | Set reverse proxy to handle traffic
  #  -----------------------------------------------
  reverse-proxy:
    image: jwilder/nginx-proxy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./certs:/etc/nginx/certs
      - /etc/nginx/vhost.d
      - /usr/share/nginx/html
      - /var/run/docker.sock:/tmp/docker.sock:ro
    labels:
      - com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy
    restart: unless-stopped

  #  -----------------------------------------------
  #  | Set letsencrypt to menage SSL
  #  -----------------------------------------------
  letsencrypt-nginx-proxy-companion:
    image: jrcs/letsencrypt-nginx-proxy-companion
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./certs:/etc/nginx/certs:rw
      - /var/run/docker.sock:/var/run/docker.sock:ro
    volumes_from:
      - reverse-proxy
    restart: unless-stopped

#  -----------------------------------------------
#  | Set services
#  -----------------------------------------------
  wordpress_app1_name:
    image: wordpress:php7.2
    environment:
      - WORDPRESS_DB_HOST=host.docker.internal:3306
      - WORDPRESS_DB_USER=db1user
      - WORDPRESS_DB_PASSWORD=password
      - VIRTUAL_HOST=www.app1_host.com
      - LETSENCRYPT_HOST=www.app1_host.com
      - LETSENCRYPT_EMAIL=confirmation_email@app1_host.com
    volumes:
      - ./app_1_volume:/var/www/html
      - ./app_1_uploads.ini:/usr/local/etc/php/conf.d/uploads.ini
    restart: unless-stopped
    
    
  wordpress_app2_name:
    image: wordpress:php5.6
    environment:
      - WORDPRESS_DB_HOST=host.docker.internal:3306
      - WORDPRESS_DB_USER=db1user
      - WORDPRESS_DB_PASSWORD=password
      - VIRTUAL_HOST=www.app1_host.com
      - LETSENCRYPT_HOST=www.app1_host.com
      - LETSENCRYPT_EMAIL=confirmation_email@app1_host.com
    volumes:
      - ./app_2_volume:/var/www/html
      - ./app_2_uploads.ini:/usr/local/etc/php/conf.d/uploads.ini
    restart: unless-stopped
```