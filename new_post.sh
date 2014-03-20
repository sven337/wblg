#!/bin/bash

read -p 'Enter title: ' title


NAME=`date --iso-8601`-$(echo $title | sed 's/ /-/g' | tr -d -c '[:alnum:]-').markdown
NEW_FILE=_drafts/$NAME

if [ -f $NEW_FILE -o -f _posts/$NAME ]; then
	echo "File already exists!!!"
	exit 1
fi

cat > $NEW_FILE << EOF
---
layout: post
title: $title
date: $(date '+%Y-%m-%d %H:%M:%S')
tags: XXX
category: XXX
comments: true
img_rel: "/~sven337/data/XXX"
---
EOF

vim $NEW_FILE
