#! /bin/bash
echo "getting gamepower revision $1"
svn co -r $1 https://gamepower.svn.sourceforge.net/svnroot/gamepower gamepower.$1
