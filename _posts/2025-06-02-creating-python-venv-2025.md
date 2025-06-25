---
layout: post
title: Creating a new Python virtual env in 2025
comments: true
tags: [python,venv,uv]
---

The approach I use to create and activate a new Python virtual environment in 2025 is illustrated below:

```bash
uv venv --seed -p=python3.13
. .venv/bin/activate
```
