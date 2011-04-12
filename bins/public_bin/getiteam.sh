#! /bin/bash

checkout()
{
	svn co https://i-team.svn.sourceforge.net/svnroot/i-team i-team
	svn co https://gamepower.svn.sourceforge.net/svnroot/gamepower gamepower
}

echo "checkout i-team and gamepower into this directory?"
read ans
case $ans in
	y|Y|yes) checkout;;
esac
