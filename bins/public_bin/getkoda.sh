#! /bin/bash

checkout()
{
	svn co https://koda.svn.sourceforge.net/svnroot/koda koda
}

echo "checkout koda into this directory?"
read ans
case $ans in
	y|Y|yes) checkout;;
esac
