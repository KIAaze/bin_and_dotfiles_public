#!/bin/bash
set -e -u

echo $#

# Check if all parameters are present
# If no, exit
if [ $# -ne 7 ]
then
        echo "usage :"
        echo "`basename $0` file destdir M H DOM MON DOW"
	echo "min(0 - 59)"
	echo "hour(0 - 23)"
	echo "day of month(1 - 31)"
	echo "month(1 - 12)"
	echo "day of week(0 - 6)(Sunday=0)"
        exit 0
fi

srcname=`basename $1`
srcdir=`dirname $1`
srcdir=`cd $srcdir; pwd`
src=$srcdir/$srcname
encrypted=$srcname.gpg
destdir=`cd $2; pwd`
M=$3
H=$4
DOM=$5
MON=$6
DOW=$7
SUDO_CMD=""

echo "srcname=$srcname"
echo "srcdir=$srcdir"
echo "src=$src"
echo "encrypted=$encrypted"
echo "destdir=$destdir"
echo "M=$M"
echo "H=$H"
echo "DOM=$DOM"
echo "MON=$MON"
echo "DOW=$DOW"
echo "SUDO_CMD=$SUDO_CMD"

encrypt.sh $src
$SUDO_CMD mv -iv $srcdir/$encrypted $destdir
$SUDO_CMD chmod 000 $destdir/$encrypted
$SUDO_CMD crontab_add.sh "$M $H $DOM $MON $DOW chmod 755 $destdir/$encrypted"
echo "===================="
ls -l $destdir/$encrypted
echo "===================="

echo "shred $src?(y/n)"
read ans
case $ans in
  y|Y|yes) shred.sh $src && exit 0;;
  *) echo "exiting" && exit 1;;
esac
