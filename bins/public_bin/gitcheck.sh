#!/bin/sh

# source: http://stackoverflow.com/questions/3258243/git-check-if-pull-needed

# Use "git fetch SOURCE" if not all remotes are available (and you want to compare to a specific source). Else, use "git remote update".
# git remote update

# IMPORTANT: need way to specify remote/base sources! The current script only works for the default remote!

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

echo "LOCAL=${LOCAL}"
echo "REMOTE=${REMOTE}"
echo "BASE=${BASE}"

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
