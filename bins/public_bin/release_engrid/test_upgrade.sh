#!/bin/bash
set -e -u -x

OLD=$1
NEW=$2

#purge previous installs
sudo apt-get remove --purge webcontentcontrol

#install the old version
sudo gdebi ./release/webcontentcontrol_$OLD-0ubuntu1_i386.deb

#upgrade from the previous version
sudo gdebi ./release/webcontentcontrol_$NEW-0ubuntu1_i386.deb

#downgrade back again and then remove it,
sudo dpkg -i ./release/webcontentcontrol_$OLD-0ubuntu1_i386.deb
sudo apt-get remove webcontentcontrol

#install the new package
sudo gdebi ./release/webcontentcontrol_$NEW-0ubuntu1_i386.deb

#remove it and then reinstall it again,
sudo apt-get remove webcontentcontrol
sudo gdebi ./release/webcontentcontrol_$NEW-0ubuntu1_i386.deb

#purge it.
sudo apt-get remove --purge webcontentcontrol
