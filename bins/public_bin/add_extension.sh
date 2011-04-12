#!/bin/bash

add_extension()
{
	EXT=$2
	DIR=$(dirname "$1")
	filename=$DIR/$(basename "$1" .$EXT).$EXT
	echo $filename
}

filename=$(add_extension $1 $2)
echo $filename

