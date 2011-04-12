#! /bin/bash

update()
{
	cd gamepower
	pwd
	svn update
	svn log > gamepower.log

	cd ../i-team
	pwd
	svn update
	svn log > iteam.log

	cd ../isoccer
	pwd
	svn update
	svn log > isoccer.log

	cd ../koda
	pwd
	svn update
	svn log > koda.log

	~/bin/say.sh "Update finished."
}

echo "update all projects in this directory?"
read ans
case $ans in
        y|Y|yes) update;;
esac
