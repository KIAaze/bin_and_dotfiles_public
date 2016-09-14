#!/bin/sh

# source: http://stackoverflow.com/questions/3258243/git-check-if-pull-needed

# Use "git fetch SOURCE" if not all remotes are available (and you want to compare to a specific source). Else, use "git remote update".
# git remote update

# IMPORTANT: need way to specify remote/base sources! The current script only works for the default remote!

# @
#     @ alone is a shortcut for HEAD.
# <branchname>@{upstream}, e.g. master@{upstream}, @{u}
# 
#     The suffix @{upstream} to a branchname (short form <branchname>@{u}) refers to the branch that the branch specified by branchname is set to build on top of (configured with branch.<name>.remote and branch.<name>.merge). A missing branchname defaults to the current one.
# https://git-scm.com/docs/gitrevisions
# :-master@{upstream}}
# REMOTE_REVSPEC=${1:-master@{upstream}}
# REMOTE_NAME=${1:$(git config branch.${BRANCH}.remote)}

# could probably also just use "git diff --exit-code master remote/master", but this script gives more specific info (need to pull, need to push or diverged)

LOCAL_REVSPEC=HEAD
BRANCH=$(git rev-parse --abbrev-ref ${LOCAL_REVSPEC})

if [ -z ${1+x} ]
then
  # default
  REMOTE_NAME=$(git config branch.${BRANCH}.remote)
else
  REMOTE_NAME=${1}
fi

REMOTE_REVSPEC=remotes/${REMOTE_NAME}/${BRANCH}

echo "LOCAL_REVSPEC = ${LOCAL_REVSPEC}"
echo "BRANCH = ${BRANCH}"
echo "REMOTE_NAME = ${REMOTE_NAME}"
echo "REMOTE_REVSPEC = ${REMOTE_REVSPEC}"

if ! git fetch ${REMOTE_NAME}
then
  echo "git fetch ${REMOTE_NAME} failed"
  exit 1
fi

LOCAL_SHA1=$(git rev-parse ${LOCAL_REVSPEC})
REMOTE_SHA1=$(git rev-parse ${REMOTE_REVSPEC})
BASE_SHA1=$(git merge-base ${LOCAL_REVSPEC} ${REMOTE_REVSPEC})

echo "LOCAL_SHA1 = ${LOCAL_SHA1}"
echo "REMOTE_SHA1 = ${REMOTE_SHA1}"
echo "BASE_SHA1 = ${BASE_SHA1}"

if [ ${LOCAL_SHA1} = ${REMOTE_SHA1} ]; then
    echo "Up-to-date"
    exit 0
elif [ ${LOCAL_SHA1} = ${BASE_SHA1} ]; then
    echo "Need to pull"
    exit 1
elif [ ${REMOTE_SHA1} = ${BASE_SHA1} ]; then
    echo "Need to push"
#     exit 0
    exit 2
else
    echo "Diverged"
#     exit 1
    exit 3
fi
