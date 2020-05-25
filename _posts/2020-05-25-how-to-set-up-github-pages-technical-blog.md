---
layout: post
title: How to set up a GitHub Pages technical blog?
description: Post that describes how to set up a GitHub Pages site for a technical blog like this one.
summary: How to set up a GitHub Pages technical blog?
comments: true
tags: [blog,gh-pages]
---

This post describes how to set up a GitHub Pages site for a technical blog like this one.

1. Create a GitHub repository for hosting the blog source files: [gh-pages-blog-template](https://github.com/ovidiuparvu/gh-pages-blog-template/generate).
2. Clone the GitHub repository created at step 1 into a local directory, which will be denoted as `BLOG_DIR` for the remainder of this post.
3. Set up [Ruby](https://www.ruby-lang.org/en/documentation/installation/) and [Bundler](https://bundler.io/) locally.
4. Install the gems required for testing the blog locally by running in the `BLOG_DIR` directory the following:
    ```
    bundle install
    ```
5. Test the blog locally by running in the `BLOG_DIR` directory the command below and opening in a browser the URL printed when running the command:
    ```
    bundle exec jekyll serve
    ```
6. Customize the structure and contents of the blog to your own liking. If you are new to Jekyll, going through the [Step by Step Tutorial](https://jekyllrb.com/docs/step-by-step/01-setup) could help.
    - Search for all occurrences of the string `YOUR_NAME` in the `BLOG_DIR` directory and replace them (and the surrounding text) as needed.
