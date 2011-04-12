#!/bin/bash
set -eux

usage()
{
  echo "USAGE EXAMPLE:"
  echo "`basename $0` DialogLineEdit HoldTheLine"
  echo "This creates a new widget named HoldTheLine based on DialogLineEdit. :)"
  echo "IMPORTANT: For this script to work correctly, the names must be camel case with upper case first letter!!!!!!!"
}

# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
	usage;
	exit 0;
fi

#Convert the given argument into an all lower case string.
toLower() {
  echo $1 | tr "[:upper:]" "[:lower:]" 
}

#Convert the given argument into an all upper case string.
toUpper() {
  echo $1 | tr "[:lower:]" "[:upper:]" 
}

#Convert the given argument into a capitalized string.
toCapitalized() {
  echo $1  | python -c "print raw_input().capitalize()"
}

toLowerCaseFirstCharacter() {
#   space_out_camel_case.py $1
  LowerCaseFirstCharacter.py $1
}

oldcamelname=$1
newcamelname=$2

# create names
oldlowername=$(toLower $oldcamelname)
olduppername=$(toUpper $oldcamelname)
oldcapitalname=$(toCapitalized $oldcamelname)
oldlowerfirstname=$(toLowerCaseFirstCharacter $oldcamelname)

newlowername=$(toLower $newcamelname)
newuppername=$(toUpper $newcamelname)
newcapitalname=$(toCapitalized $newcamelname)
newlowerfirstname=$(toLowerCaseFirstCharacter $newcamelname)

echo oldlowername=$oldlowername
echo olduppername=$olduppername
echo oldcapitalname=$oldcapitalname
echo oldlowerfirstname=$oldlowerfirstname

echo newlowername=$newlowername
echo newuppername=$newuppername
echo newcapitalname=$newcapitalname
echo newlowerfirstname=$newlowerfirstname

# echo $oldlowername\plugin.pro
# exit 0

#clean up
cd $oldlowername
qmake test.pro && make distclean
qmake $oldlowername\plugin.pro && make distclean
rm -fv *.orig
cd ..

# copy files
mkdir $newlowername
ls -1 $oldlowername | grep -v designer | xargs -n1 -I{} cp -v $oldlowername/{} $newlowername
# cp -r $oldlowername $newlowername
cd $newlowername

# rename files
# on openSUSE
if rename $oldlowername $newlowername *
then
  echo "file renaming successful"
else
  #on kubuntu (perl rename?)
  rename "s/$oldlowername/$newlowername/" *
  echo "file renaming successful"
fi

# process files
ls -1 | xargs -n1 -I{} sed -i -e "s/$oldlowername/$newlowername/g" {}
ls -1 | xargs -n1 -I{} sed -i -e "s/$oldcamelname/$newcamelname/g" {}
ls -1 | xargs -n1 -I{} sed -i -e "s/$olduppername/$newuppername/g" {}
ls -1 | xargs -n1 -I{} sed -i -e "s/$oldcapitalname/$newcapitalname/g" {}
ls -1 | xargs -n1 -I{} sed -i -e "s/$oldlowerfirstname/$newlowerfirstname/g" {}

#check for errors
if grep -i $oldlowername *
then
  echo "ERROR: There are still traces of $oldlowername left."
else
  echo SUCCESS
fi
