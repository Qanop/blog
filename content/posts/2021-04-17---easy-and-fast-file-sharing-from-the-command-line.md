--- 
title: Easy and fast file sharing from the command-line
date: "2021-04-17T23:17:32.000Z" 
template: "post" 
draft: false 
slug: "easy-and-fast-file-sharing-from-the-command-line" 
category: "Technology" 
tags: 
  - "Technology" 
  - "Ops / DevOps" 
description: "Looking for a quick and easy-to-use option to share and send files, I came across transfer.sh. As it turns out, this is an ideal form of file sharing like WeTransfer or mega.nz, but for sending files via CLI." 
socialImage: "media/server-9.jpg" 
---
Looking for a quick and easy-to-use option to share and send files, I came across transfer.sh. As it turns out, this is an ideal form of file sharing like WeTransfer or mega.nz, but for sending files via CLI. Obviously, the best option for sending files is direct data transfer using SCP or rsync. But for Polish people that we can go public or servers that don't have direct IP or exit, this is an interesting option.

When it comes to sending files, curl is enough for us
```shell
# Upload using cURL 
$ curl --upload-file ./hello.txt https://transfer.sh/hello.txt 
https://transfer.sh/66nb8/hello.txt
```

On the website [https://transfer.sh/](transfer.sh) we can see many options for using the tool. We have automatic packing of files to tar.gz or zip archives, examples of data encryption before uploading, malware scanning, use of [https://keybase.io/](keybase.io), and much more. The project even has a website at [http://jxm5d6emw5rknovg.onion/](a Tor network)
