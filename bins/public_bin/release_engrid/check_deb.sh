#!/bin/bash
set -e -u -x
echo ".deb=$1"

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

sudo gdebi $1
/usr/bin/webcontentcontrol
sudo apt-get remove --purge webcontentcontrol
