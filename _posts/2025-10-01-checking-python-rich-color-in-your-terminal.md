---
layout: post
title: Checking how a Python `rich` color looks in your terminal
comments: true
tags: [rich,python,colour,color]
---

Check how a [rich](https://rich.readthedocs.io) colour looks in your terminal as follows.

```shell
echo "from rich.console import Console; Console().print('[bright_black]Sample text[/bright_black]');" | uv run --with rich -
```