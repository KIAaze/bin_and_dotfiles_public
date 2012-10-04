#!/bin/bash

set -eux

# variables to change depending on desired package
BRANCH="release"
VERSION="1.2rc1"

# other variables
GITDIR=$(readlink -f $1)
BASE="engrid-$VERSION"
ARCHIVE=$BASE.tar.gz

ORIG=$(pwd)

cd $GITDIR
git checkout $BRANCH
git archive --format=tar --prefix=$BASE/ HEAD | gzip >$ORIG/$ARCHIVE

cd $ORIG
