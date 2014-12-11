#! /bin/sh
echo "BACKING UP ~/cbmroot and ~/MyBuild_32 (except *.root files)"
cd ~
echo "creating ~/cbmroot.tar.gz"
tar --exclude=*.root -czvf ~/cbmroot.tar.gz ./cbmroot/
echo "creating ~/MyBuild_32.tar.gz"
tar --exclude=*.root -czvf ~/MyBuild_32.tar.gz ./MyBuild_32/
