#! /bin/bash
echo "UPDATING CBMROOT:"
cd ~
svn export --force  https://subversion.gsi.de/fairroot/cbmroot
. /misc/cbmsoft/config/CbmEnv.sh new
mkdir MyBuild_32
cd cbmroot
./reconf
cd ~/MyBuild_32
~/cbmroot/configure  --prefix=$PWD --enable-geant3
. ./config.sh
make
make install
