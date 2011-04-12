#!/bin/bash
set -eux

for OBJ in "$@"
do
	FULLPATH=$(readlink -f $OBJ)
	echo $FULLPATH
	mv -iv "$FULLPATH" $HOME/Private/ && ln -s $HOME/Private/$(basename "$FULLPATH") $(dirname $FULLPATH)
done
