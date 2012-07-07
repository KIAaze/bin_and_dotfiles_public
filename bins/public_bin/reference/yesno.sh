#! /bin/bash

echo "install?"
read ans
case $ans in
  y|Y|yes) echo "first line"
		echo install;;
  q) echo quitting;;
  *) echo "next step";;
esac

if zenity --question --text "OK?"
then
	echo OK
else
	echo "not OK"
fi

