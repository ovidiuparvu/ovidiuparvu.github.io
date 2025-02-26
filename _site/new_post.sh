#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: new_post.sh <post_name>";
  exit 1;
fi

newPostFileNameSuffix="$1";
newPostFilePath="_posts/$(date +"%Y-%m-%d")-${newPostFileNameSuffix}.md";
touch "$newPostFilePath";
code "$newPostFilePath";