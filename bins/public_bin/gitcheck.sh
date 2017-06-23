#!/bin/bash
#
# Script to compare local and remote git repositories.
#
# Usage:
#   gitcheck.sh [REMOTE]
#
# If REMOTE is not specified, it uses the default remote used for pull/push operations.
#
# Exit status:
#   0 : Up-to-date
#   1 : Need to pull
#   2 : Need to push
#   3 : Diverged
#   4 : ERROR: git fetch failed
#
# Notes:
#   -based on a script from: http://stackoverflow.com/questions/3258243/git-check-if-pull-needed
#   -Use "git fetch SOURCE" if not all remotes are available (and you want to compare to a specific source). Else, use "git remote update".
#   -cf https://git-scm.com/docs/gitrevisions
#   -Could probably also just use "git diff --exit-code master remote/master", but this script gives more specific info (need to pull, need to push or diverged)
#   -for a much more advanced version, see https://github.com/badele/gitcheck

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

# echo "LOCAL_REVSPEC = ${LOCAL_REVSPEC}"
# echo "BRANCH = ${BRANCH}"
# echo "REMOTE_NAME = ${REMOTE_NAME}"
# echo "REMOTE_REVSPEC = ${REMOTE_REVSPEC}"

if ! git fetch ${REMOTE_NAME}
then
  echo "git fetch ${REMOTE_NAME} failed"
  exit 4
fi

LOCAL_SHA1=$(git rev-parse ${LOCAL_REVSPEC})
REMOTE_SHA1=$(git rev-parse ${REMOTE_REVSPEC})
BASE_SHA1=$(git merge-base ${LOCAL_REVSPEC} ${REMOTE_REVSPEC})

# echo "LOCAL_SHA1 = ${LOCAL_SHA1}"
# echo "REMOTE_SHA1 = ${REMOTE_SHA1}"
# echo "BASE_SHA1 = ${BASE_SHA1}"

if [ ${LOCAL_SHA1} = ${REMOTE_SHA1} ]; then
    echo "Up-to-date"
    exit 0
elif [ ${LOCAL_SHA1} = ${BASE_SHA1} ]; then
    echo "Need to pull"
    exit 1
elif [ ${REMOTE_SHA1} = ${BASE_SHA1} ]; then
    echo "Need to push"
    exit 2
else
    echo "Diverged"
    exit 3
fi
