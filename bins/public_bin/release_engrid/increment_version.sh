#!/bin/bash
set -e -u

VERSION=`awk -F, '/AC_INIT/ {print $2}' ./configure.ac`

increment()
{
    echo "===>Incrementing from $1 to $2"
    #configure.ac
    sed -i.bak "s/$1/$2/" ./configure.ac
    #debian/changelog
#     sed -i.bak "s/$1/$2/" ./debian/changelog
    #Gambas project file
    sed -i.bak "s/$1/$2/" ./webcontentcontrol_GUI/.project
    #Update configure+makefile.in
    ./autogen.sh
    echo "===>Version nb incremented successfully."
}

nextversion()
{
    TMP=`mktemp`
    echo $1 >$TMP
    a=$(awk -F. '{print $1}' $TMP)
    b=$(awk -F. '{print $2}' $TMP)
    c=$(awk -F. '{print $3}' $TMP)

    c=$( expr $c + 1 )
    if [ $c -ge 10 ]
    then
	c=0
	b=$( expr $b + 1 )
	if [ $b -ge 10 ]
	then
	    b=0
	    a=$( expr $a + 1 )
	fi
    fi

    echo $a.$b.$c
}

echo "Current directory=$(pwd)"

#increment version nb
CURRENT=$VERSION
NEXT=$(nextversion $CURRENT)

echo "Increment version nb from $CURRENT to $NEXT ? (y/n/q)"
read ans
case $ans in
y|Y|yes) increment $CURRENT $NEXT;;
q) echo "exiting" && exit 1;;
*) echo "Not incrementing.";;
esac
