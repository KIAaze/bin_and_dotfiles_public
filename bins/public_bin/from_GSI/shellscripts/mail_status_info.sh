#! /bin/bash

/u/$USER_flast/bin/shellscripts/status_info.sh 1>status.txt 2>subject.txt;
status=`cat subject.txt`;
mail -s $status $USER_flast@gsi.de < status.txt;
