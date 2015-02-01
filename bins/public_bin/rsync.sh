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
  n) DFLAGS="";;
  a) DFLAGS="--delete-after";;
  b) DFLAGS="--delete-before";;
  i) DFLAGS="--dry-run --info=DEL1 --delete-after";;
  q) exit;;
  *) exit;;
esac

echo "skip any files which exist on the destination and have a modified time that is newer than the source file (y/n)? quit(q)?"
read ans
case $ans in
  y) UFLAGS="--update --info SKIP";;
  n) UFLAGS="";;
  q) exit;;
  *) exit;;
esac

STANDARD_FLAGS="--archive --compress"

CMD="time rsync ${STANDARD_FLAGS} ${UFLAGS} ${DFLAGS} ${SRCDIR}/ ${DSTDIR}/"

# show command that will be used
echo "Command used:"
echo "${CMD}"

# ask for confirmation and execute if answer is yes
echo "confirm (yes/no)"
read ans
case $ans in
  yes) ${CMD} ;;
  *) exit;;
esac
