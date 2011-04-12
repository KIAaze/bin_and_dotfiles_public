#!/bin/bash

rm -iv *.tar.gz

set -eux

# Check if all parameters are present
# If no, exit
if [ $# -ne 3 ]
then
        echo "usage :"
        echo "`basename $0` NAME MAIL NOUPLOAD"
        exit 1
fi

NAME=$1
MAIL=$2
NOUPLOAD=$3
echo "NAME=$NAME"
echo "MAIL=$MAIL"

PKGDIR=./release

if [ -e $PKGDIR ]
then
	echo "rm -rfv $PKGDIR ?"
	read ans
	case $ans in
	  y|Y|yes) rm -rfv $PKGDIR;;
	esac
fi

#write something into changelog
dch -i
#do it again to check for errors (script will exit on error)
dch -e
FULLVERSION=$(./testing/getVersion.py)

STARTDIR=$(pwd)

mkdir -p $PKGDIR

VERSION=`awk -F, '/AC_INIT/ {print $2}' ./configure.ac`
TARBALL="./webcontentcontrol-$VERSION.tar.gz"
TARBALL2="./webcontentcontrol_$VERSION.orig.tar.gz"

# DEB="./webcontentcontrol_$VERSION-1_i386.deb"
# DEB2="./webcontentcontrol_$VERSION-0ubuntu1_i386.deb"

if [ $(uname -m) = "x86_64" ]
then
        ARCH="amd64"
else
        ARCH="i386"
fi

DEB="./webcontentcontrol_$VERSION-0ubuntu1_$ARCH.deb"

echo ARCH=$ARCH
echo "PKGDIR=$PKGDIR"
echo "VERSION=$VERSION"
echo "TARBALL=$TARBALL"
echo "DEB=$DEB"

./autogen.sh
./testing/make_tarball.sh .
./testing/make_deb.sh $TARBALL $PKGDIR "$NAME" $MAIL

#cp $TARBALL $PKGDIR
cd $PKGDIR

echo "Signing tarball for launchpad upload:"
gpg -u $MAIL --armor --sign --detach-sig $TARBALL2
# echo "Signing .deb for launchpad upload:"
# gpg --armor --sign --detach-sig $DEB

#confirm results visually
echo "============"
ls -lrt
echo "============"

if [ $NOUPLOAD -eq 1 ]
then
  exit 0;
fi

#Upload to PPA :)
dput ppa:webcontentcontrol/webcontentcontrol  webcontentcontrol_$FULLVERSION\_source.changes
# dput $DPUT_USER webcontentcontrol_$VERSION-0ubuntu1_source.changes

#Return to initial dir
cd $STARTDIR
echo "Current directory=$(pwd)"

./testing/increment_version.sh
