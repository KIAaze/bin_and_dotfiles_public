#!/bin/sh

# source: http://stackoverflow.com/questions/3258243/git-check-if-pull-needed

git remote update

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
    exit 0
elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
    exit 1
elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
    exit 0
else
    echo "Diverged"
    exit 1
fi
