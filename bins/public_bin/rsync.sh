#!/bin/bash

# rsync wrapper script with various options and some interactivity

# Check if all parameters are present. If not, exit.
if [ $# -ne 2 ]
then
  echo "Usage :"
  echo "$(basename $0) SRCDIR DSTDIR"
  exit 1
fi

# set variables
SRCDIR=$1
DSTDIR=$2

# set desired flags
echo "delete nothing on destination(n)? --delete-after(a)? --delete-before(b)? show what would be deleted, but do nothing(i)? quit(q)?"
read ans
case $ans in
  n) FLAGS="";;
  a) FLAGS="--delete-after";;
  b) FLAGS="--delete-before";;
  i) FLAGS="--dry-run --info=DEL1 --delete-after";;
  q) exit;;
  *) exit;;
esac

# show command that will be used
echo "Command used:"
echo "time rsync --archive --compress ${FLAGS} ${SRCDIR}/ ${DSTDIR}/"

# ask for confirmation and execute if answer is yes
echo "confirm (yes/no)"
read ans
case $ans in
  yes) time rsync --archive --compress ${FLAGS} ${SRCDIR}/ ${DSTDIR}/ ;;
  *) exit;;
esac
