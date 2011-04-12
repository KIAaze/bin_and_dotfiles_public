#! /bin/bash

update()
{
	cd src
	pwd
	cvs update

	cd ../manual
	pwd
	cvs update

	~/bin/totalnotify.sh "Update finished."
}

echo "update all projects in this directory?"
read ans
case $ans in
        y|Y|yes) update;;
esac
