#!/bin/bash

LOCATION="$HOME/Development/engrid/src/netgen_svn"

symlink()
{
	ln -s $LOCATION/libng.a
	ln -s $LOCATION/netgen-mesher
}

echo "create symlinks to netgen stuff here?"
read ans
case $ans in
  y|Y|yes) symlink;;
  *) echo quitting;;
esac
