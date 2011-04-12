#!/bin/bash
set -e -u -x

# Check if all parameters are present
# If no, exit
if [ $# -ne 4 ]
then
        echo "usage :"
        echo "`basename $0` TARBALL PKG_DIR NAME MAIL"
        exit 1
fi

TARBALL=$1
PKG_DIR=$2
NAME=$3
MAIL=$4

echo "tarball=$TARBALL"
echo "pkg_dir=$PKG_DIR"

DIR=`dirname $TARBALL`
# EXTRACTED=`basename $TARBALL .tar.gz`
VERSION=`awk -F, '/AC_INIT/ {print $2}' ./configure.ac`
EXTRACTED="webcontentcontrol-$VERSION"
mkdir -p $PKG_DIR

if [ -e $PKG_DIR/$EXTRACTED ]
then
    echo "$PKG_DIR/$EXTRACTED exists. Do you want to remove it? (y/n/q)"
    read ans
    case $ans in
    y|Y|yes) rm -rf $PKG_DIR/$EXTRACTED && echo "$PKG_DIR/$EXTRACTED removed.";;
    q) echo "exiting" && exit 1;;
    *) echo "Ok, not removing it.";;
    esac
fi

tar -xzvf $TARBALL -C $PKG_DIR
cp -v $TARBALL $PKG_DIR/$EXTRACTED.orig.tar.gz
rename -v 's/-/_/g' $PKG_DIR/$EXTRACTED.orig.tar.gz
cd $PKG_DIR/$EXTRACTED

# TODO: Improve script by reusing existing debian files...
# 
export DEBFULLNAME="$NAME"
dh_make -a -n -s -e $MAIL -c gpl
rm debian/*.ex debian/*.EX
rm debian/README debian/README.Debian
#fakeroot debian/rules clean
#debian/rules build
#fakeroot debian/rules binary
#cat debian/webcontentcontrol/DEBIAN/control
#debuild -us -uc

#create&sign .deb
debuild
#create&sign .tar.gz
debuild -S -sa
