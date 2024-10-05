---
layout: post
title: How can I create a command line tool that creates a plot using plotly and opens it in your browser?
description: How can I create a command line tool that creates a plot using plotly and opens it in your browser?
summary: Create a command line tool using typer that creates and exports to HTML a plot using plotly and then opens it up in your local browser.
comments: true
tags: [typer,pyton,cli,plotly,browser,www,html]
---

One approach is to use [typer](https://typer.tiangolo.com/) to create the command line tool and use [plotly](https://plotly.com/python/) to create the plot with the auto_open (in browser) option set to `True`.

Sample code [here](https://github.com/ovidiuparvu/cli-plotly-html/blob/main/app.py).

