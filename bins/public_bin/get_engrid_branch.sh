#!/usr/bin/env bash

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo "usage :"
        echo "`basename $0` BRANCH"
        exit 0
fi

BRANCH=$1

git clone ssh://$HOST_SF/srv/www/htdocs/git/engrid.git ./engrid_$BRANCH
cd ./engrid_$BRANCH

if ! [ $BRANCH = "master" ]
then
  echo "not master"
  git checkout -b $BRANCH origin/$BRANCH
fi
