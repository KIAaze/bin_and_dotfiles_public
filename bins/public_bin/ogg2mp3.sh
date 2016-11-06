#!/bin/bash
for i in "$@"
do
	avconv -i "${i}" "${i%.ogg}.mp3"
done
