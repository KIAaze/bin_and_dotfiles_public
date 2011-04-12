#!/bin/bash

FILE=./upgradable.txt
FILE2=/tmp/upgradable2.txt

usage()
{
	echo "usage 1: `basename $0` [UPGRADABLE.TXT]"
	echo "usage 2: `basename $0` -h : To get this help message"
	echo "If UPGRADABLE.TXT is not specified, it will default to $FILE."
	echo "If UPGRADABLE.TXT does not exist or is empty, it will be generated."
	echo "If UPGRADABLE.TXT does exist and is non-empty, you will be asked wether you want to reuse it or not."
	echo "If you do not want to reuse it, it will be generated."
	exit 0
}

generate_package_list()
{
    ################################
    #Create upgradable package list
    ################################
    echo "Generating new $FILE. This may take a while..."
    ~/bin/list_upgradable_packages.pl >$FILE && echo "$FILE created"

    ~/bin/totalnotify.sh "Finished generating package list"
}

adapt_package_list()
{
    #########################
    #backup and adapt file
    #########################
    cp -v $FILE $FILE.$(date +%Y%m%d_%H%M%S)
    sed -i 's/ \+/\n/g' $FILE
    sed -i '/^$/ d' $FILE

    cat $FILE | tr '\n' ' ' >$FILE2

    if [ ! -s $FILE2 ]
    then
	echo "ERROR: Generated file is empty. Exiting."
	exit 1
    fi

    ################################
    #Sort list by package size
    ################################
    echo "Sorting list by package size. This may take a while..."
    cat $FILE2 | xargs -n1 ~/bin/sizeof_package.sh | sort -n -r | awk '{print $2}' >$FILE
    echo "$FILE sorted by size"

    ~/bin/totalnotify.sh "Finished adapting package list"
}

upgrade()
{
    #########################
    #upgrade
    #########################
    PROG=`head -n1 $FILE`

    while test ! -z $PROG
    do
    echo "=== UPGRADING $PROG ==="
    ~/bin/say.sh "UPGRADING $PROG"
    df -h /
    sudo apt-get install $PROG && sudo apt-get clean && sed -i '/'$PROG'/ d' $FILE
    if [ ! $? -eq 0 ]
    then
    echo "THERE WAS AN ERROR. EXITING."
    exit 1
    fi
    PROG=`head -n1 $FILE`
    done
}

if [ $# -eq 1 ]
then
	if [ $1 = '-h' ]
	then
	    usage
	else
	    FILE=$1
	fi
fi

if [ -s $FILE ]
then
    echo "$FILE exists and is non-empty. Nb of lines:"
    wc -l $FILE
    echo "Do you want to use it? (y/n)"
    read ans
    case $ans in
    y|Y|yes) echo "Ok, using existing $FILE";;
    *) generate_package_list;;
    esac
else
    echo "WARNING: $FILE does not exist or is empty. A new one will be generated."
    generate_package_list
fi

adapt_package_list
echo "Nb of packages in $FILE:"
wc -l $FILE
echo "Do you wish to start the upgrade using $FILE ? (y/n)"
read ans
case $ans in
y|Y|yes) upgrade;;
*) exit 1;;
esac
exit 0
