---
title: Magic of whiptail and Squid proxy installation
date: "2020-11-04T21:50:47.000Z"
template: "post"
draft: false
slug: "magic-of-whiptail-squid-proxy-instalation"
category: "Technology"
tags:
  - "Technology"
  - "Server"
  - "Programming"
  - "Code Snippets"
description: "When installing a bash open source project, I was always full of admiration for the developers who implemented the graphical interface. I was curious how it works and how I could apply it to my projects. The solution is simple - whiptail"
socialImage: "media/code-2.jpg"
---
When installing a bash open source project, I was always full of admiration for the developers who implemented the graphical interface. I was curious how it works and how I could apply it to my projects. The solution is simple. It is the whiptail.

## whiptail
Whiptail is one of the popular programs that allows you to display dialog boxes in the shell. Proper preparation of steps and good ability to write shell scripts allows you to skillfully extract a lot of information from it and use it to build automated scripts.

![Basic functions of whiptail](/media/code-2.jpg)

The basic program boxes include
- message box
- yes / no box
- input box
- password box
- text box
- menu
- check list
- radio letter
- progress gauge

So as you can see, we can ask the user for all his requirements for running the script.

## Squid — install proxy server in few simple steps
Squid is a great program for creating a proxy server. It allows you to control the flow of information, maintain access at a specific time, manage access for users or bind specific network cards to appropriate ports and more. It is a very efficient tool and its configuration at a basic level does not require much time. Therefore, recently I installed this server on one of my VPS to get to specific sources by passing my data over other IP. Of course, while it takes a few steps to install, it's always nice to have an automated task. Therefore, I created the base code using dialog boxes. In order not to take too much space on the article, it is also slimmed down with additional validation of variables and function results. After all, the code is designed to encourage work.

```shell script
#!/bin/bash

whiptailInputBox() {
    # Open window with text input

    # Parameters:
    #   $1 Box title
    #   $2 Content
    #   $3 Default

    RESULT=`whiptail --inputbox "$2" 8 78 $3 --title "$1" 3>&1 1>&2 2>&3`
    return $?
    echo $RESULT
}

whiptailPasswordBox() {
    # Open window with password input

    # Parameters:
    #   $1 Box title
    #   $2 Content
    #   $3 Default

    echo `whiptail --passwordbox "$2" 8 78 $3 --title "$1" 3>&1 1>&2 2>&3`
    return $?
    echo $RESULT
}

whiptailMessageBox() {
    # Open window as message box 

    # Parameters:
    #   $1 Box title
    #   $2 Content
    
    whiptail --title "$1" --msgbox "$2" 8 78
}

preinstall() {
    if ! [ -x "$(command -v whiptail)" ]; then
        /usr/bin/apt update
        /usr/bin/apt -y install whiptail
    fi
}

install_squid() {
    /usr/bin/apt update
    /usr/bin/apt -y install apache2-utils squid3
}

squid_configuration() {
    # Revove old squid.conf config
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl

    # Update iptables and accept port
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save

    # Reset service
    service squid restart
    update-rc.d squid defaults
}

preinstall
whiptailMessageBox "Info" "Auto installation script will guide you with configuration of squid package"
SQUID_USERNAME=$(whiptailInputBox "Squid Username" "Provide SQUID username" "")
if [ $? != 0 ]; then exit; fi
SQUID_PASSWORD=$(whiptailPasswordBox "Squid Password" "Provide SQUID password" "")
if [ $? != 0 ]; then exit; fi

install_squid
/usr/bin/htpasswd -b -c /etc/squid/passwd $SQUID_USERNAME $SQUID_PASSWORD
squid_configuration
whiptailMessageBox "Info" "Instalation complete"
```

With squid already installed, we can go to configuration. The current `squid.conf` allows us only to use the proxy locally on the server. To unlock its external use, we must remember that each service published by us should be secured. There are too many IP lists of proxy servers on the Internet that have been exposed to the public with different port values in hope that no one will guess why they are open.

To protect yourself against such situations, it is enough to unblock the proxy entry only for credentials that we created earlier using the script above. The record should be placed under the indicated comment in the `/etc/squid/squid.conf` file. After that, all you need it reset the service and you can connect to your proxy service.

```dotenv
#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Squid Basic Authentication
auth_param basic credentialsttl 2 hours
acl auth_users proxy_auth REQUIRED
http_access allow auth_users
```

## Tips
curl command can be used to test a connection through a proxy

```bash script
curl -x http://user.password@domain_or_IP:3128 -I http://google.com

# When success (Message head)
HTTP/1.1 301 Moved Permanently
Location: http://www.google.com/

# When conection is secured with proxy (Message head)
HTTP/1.1 407 Proxy Authentication Required
```

Likewise, we can get our IP after going through any proxy we provide
```bash script
wget -e use_proxy=yes -e http_proxy=http://user.password@domain_or_IP:3128 -qO- http://ipecho.net/plain | xargs echo
```