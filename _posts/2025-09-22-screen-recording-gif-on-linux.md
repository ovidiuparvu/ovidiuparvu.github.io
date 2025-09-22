---
layout: post
title: Screen recording gif on Linux
comments: true
tags: [gif,linux,recording]
---

To screen record a gif on Linux you can use [Kooha](https://github.com/SeaDve/Kooha), which can be installed as follows:

```bash
sudo apt install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.github.seadve.Kooha
```

To run Kooha from the command line, you can run the following:

```bash
flatpak run io.github.seadve.Kooha
```