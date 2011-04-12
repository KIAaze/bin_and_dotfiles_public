#! /bin/bash
#script to update CBMroot

LOGFILE=~/cbmroot_installation.log ;

#remove old logfile
#rm $LOGFILE
#start logging
echo "================================">>$LOGFILE
date >>$LOGFILE
echo "================================">>$LOGFILE

echo "UPDATING CBMROOT:"

cd ~/cbmroot
svn update
#svn export --force  https://subversion.gsi.de/fairroot/cbmroot
#svn co  https://subversion.gsi.de/fairroot/cbmroot
cd ~

. /misc/cbmsoft/config/CbmEnv.sh new
cd ~/cbmroot
./reconf
cd ~/MyBuild_32
cmake ../cbmroot
. ./config.sh
make
make install

echo "CBMroot updated."
echo "CBMroot updated." >>$LOGFILE

echo "Installation info logged in $LOGFILE";
