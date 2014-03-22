#!/bin/bash


FILE=$(find _drafts _posts -name '*.markdown' | sed -r 's,_(drafts|posts)/([0-9-]+)-(.*)\.markdown,\3\t\2\t\1\t\0,' | sort -rk 2 | sed 's/\t/\n/g' | yad --list --text="Posts" --column=Titre --column=Date --column=Type --column=file:HD  --print-column=4 --listen --separator='' --geometry 1024x800)

if [ $? -eq 0 ]; then
	vim $FILE
fi
