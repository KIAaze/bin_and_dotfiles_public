#!/bin/bash

set -eux

#get latest file
get_latest()
{
  ls -t1 $@ | head -n1
}

#TODO: get latest dir
get_latest_dir()
{
  ls -t1 $@ | head -n1
}


# DSC=$(get_latest "*.dsc")
# TGZ=$(get_latest "*.tar.gz")
# 
# echo $DSC
# echo $TGZ
# 
# exit 0

# variables to change depending on desired package
BRANCH="release"
VERSION="1.1-pre-release"

# other variables
GITDIR=$(readlink -f $1)
BASE="engrid-$VERSION"
ARCHIVE=$BASE.tar.gz

# exit 0
# 
# 
# # get last made engrid package
# apt-get source engrid
# 
# cp -iv $BASE/debian/changelog .
# 
# # extract archive and go into it
# tar -xzvf $ARCHIVE
# cp -iv ./changelog $BASE/debian/
# 
# cd $BASE

############################
#0
cd $(mktemp -d)

#1
apt-get source engrid
OLD_DIR=$(get_latest)

echo "========="
ls -lrt
echo "========="
echo "OLD_DIR=$OLD_DIR"
echo "Is this correct?"
read ans

mv $OLD_DIR{,.orig}
OLD_DIR="$OLD_DIR.orig"

#2
ORIG=$(pwd)
cd $GITDIR
git checkout $BRANCH
git archive --format=tar --prefix=$BASE/ HEAD | gzip >$ORIG/$ARCHIVE
cd $ORIG

#3
tar -xzvf $ARCHIVE
NEW_DIR=$BASE

#4
pwd
cp -iv $OLD_DIR/debian/changelog $NEW_DIR/debian/changelog

#5
cd $NEW_DIR

#6
dch -i

#7
debuild -S -sa

#8
cd ..

#9
DSC=$(get_latest "*.dsc")
NEW_FULL_BASE=$(basename $DSC .dsc)
sudo pbuilder build "$NEW_FULL_BASE.dsc"

#10
CHANGES=$(get_latest "*.changes")
echo dput cae "$NEW_FULL_BASE.changes"

#11
cd $NEW_DIR
debuild clean
cd ..
cp -riv $NEW_DIR/debian $GITDIR
############################
