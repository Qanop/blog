---
title: IaC as server automation
date: "2021-05-23T23:20:12.000Z"
template: "post"
draft: true
slug: "iac-as-server-automation"
category: "Technology"
tags:
  - "Technology"
  - "Ops / DevOps"
description: ""
socialImage: "media/notes-2.jpg"
---
Utrzymywanie serwera i aplikajci tęs się na nim znajdują jest problematyczne. Dochodzi do tego dodatkowo fakt, że każda nowa wersja wymaga aktualizacji. Wgrywajac wszystko opierając się na CI/CD może okazać się, że rozwiązanie o ile jest wystaczające dla aplikacji pisanych przez dev teamy, może być problematyczne dla większych sytemów wymagających instalacji bezporedniej oprogramowania oraz skalowania. W tym miejscu pomoże nam napisanie dodatkowego kodu opisującego architekturę systemów. 

![Infrastructure as Code](/media/notes-2.jpg)

Infrastructre as Code staje się coraz popularniejsze. Łącząc je z rozwiązaniami chmurowymi jesteśmy w stanie opisać coraz to więcej potrzebnych elementów z jakich chcemy złożyć nasz system. Rozwiązanie pozwala to na opisanie używanego serwera od jego sieci do używanych dyków i podzespołów. Niemniej jednak, dla technologii IaC istnieje wiele narzędzi. Każde ma swoje plusy i minusy, oraz swoje specyficzne zastosowania.