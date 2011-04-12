#!/bin/bash
set -e -u -x

# Check if all parameters are present
# If no, exit
if [ $# -ne 3 ]
then
        echo "usage :"
        echo "`basename $0` TARBALL TESTDIR PREFIX"
        exit 0
fi

echo "tarball=$1"
echo "testdir=$2"
echo "prefix=$3"

TARBALL=$1
TESTDIR=$2
PREFIX=$(readlink -f $3)

VERSION=`awk -F, '/AC_INIT/ {print $2}' ./configure.ac`
EXTRACTED="webcontentcontrol-$VERSION"

DIR=`dirname $TARBALL`
# EXTRACTED=`basename $TARBALL .orig.tar.gz`
PKGS="firehol tinyproxy dansguardian"

echo "sudo apt-get remove --purge $PKGS? (y/n/q)"
read ans
case $ans in
  y|Y|yes) sudo apt-get remove --purge $PKGS && echo "$PKGS have been purged.";;
  q) echo "exiting" && exit 1;;
  *) echo "Skipping this step.";;
esac

BINARY=/usr/bin/webcontentcontrol
PROGDIR=/usr/share/webcontentcontrol

if [ -e $BINARY ]
then
    sudo rm -iv $BINARY
fi

if [ -e $PROGDIR ]
then
    echo "rm -rf $PROGDIR ? (y/n/q)"
    read ans
    case $ans in
    y|Y|yes) sudo rm -rf $PROGDIR && echo "$PROGDIR removed";;
    q) echo "exiting" && exit 1;;
    *) echo "Not removing $PROGDIR";;
    esac
fi

sudo apt-get install $PKGS

mkdir -p $TESTDIR

if [ -e $TESTDIR/$EXTRACTED ]
then
    echo "$TESTDIR/$EXTRACTED exists. Do you want to remove it? (y/n/q)"
    read ans
    case $ans in
    y|Y|yes) rm -rf $TESTDIR/$EXTRACTED && echo "$TESTDIR/$EXTRACTED removed.";;
    q) echo "exiting" && exit 1;;
    *) echo "Ok, not removing it.";;
    esac
fi

tar -xzvf $TARBALL -C $TESTDIR
cd $TESTDIR/$EXTRACTED

if [ $PREFIX = '/usr' ]
then
    echo "=== testing normal install as root ==="
    ./configure && make && sudo make install
    echo "=== tested normal install as root ==="
else
    echo "=== testing install without root permissions ==="
    ./configure --prefix=$PREFIX && make && make install
    echo "=== tested install without root permissions ==="
fi

echo "Running $PREFIX/bin/webcontentcontrol from $(pwd)"
$PREFIX/bin/webcontentcontrol

if [ $PREFIX = '/usr' ]
then
    echo "=== testing normal uninstall as root ==="
    sudo make uninstall
    echo "=== tested normal uninstall as root ==="
else
    echo "=== testing uninstall without root permissions ==="
    make uninstall
    echo "=== tested uninstall without root permissions ==="
fi
