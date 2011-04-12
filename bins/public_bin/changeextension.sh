#! /bin/bash
# Change filename extensions

# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
        echo
        echo "usage :"
        echo "$0 oldext newext"
	echo "This shellscript will rename all files *oldext to *newext."
	echo "If *newext already exists, it will ask before overwriting."
	echo "The dot should be included in the arguments (i.e.: \"changeextension.sh .png .PNG\")"
	echo "Removing/adding extensions is therefore also possible by using \"\"."
        echo
        exit 0
fi

oldext=$1
newext=$2

files=`find . -name "*$oldext"`

for f in $files;
do
	dir=`dirname $f`
	base=`basename $f $oldext`
	mv -iv $f $dir/$base$newext
done
