#!/bin/bash

MAXTIME=15
MAXSTEPS=200

clear
echo ''
echo 'Trying 127.0.0.1...'
sleep 1
echo 'Connected to departmentofdefense.gov'
echo "Escape character is '^]'."
echo ''
sleep 1
echo -n 'administrator login: '
read LOGIN
sleep 1
echo '2250 OK'
echo -n 'password: '
read PASS
sleep 2
echo ''
echo "Goodmorning $LOGIN"
echo 'Welcome back to the [U.S.] Department of Defense'
sleep 2
echo 'Loading Countries...'
progress_bar.sh $(($MAXTIME*$RANDOM/32767)) $(($MAXSTEPS*$RANDOM/32767))
echo 'Which country would you like to attack?'

echo ''
echo 'Iran......[1]'
echo 'Iraq......[2]'
echo 'Pakistan..[3]'
echo 'China.....[4]'
echo 'Japan.....[5]'
echo 'Russia....[6]'
echo ''
read COUNTRY

echo '' 
echo "Preparing to attack country #$COUNTRY..."
progress_bar.sh $(($MAXTIME*$RANDOM/32767)) $(($MAXSTEPS*$RANDOM/32767))
echo ''
echo 'Loading weapons...'
progress_bar.sh $(($MAXTIME*$RANDOM/32767)) $(($MAXSTEPS*$RANDOM/32767))
echo 'Please choose your prefered method of destruction:'

echo ''
echo 'Nuclear Bomb.....[1]'
echo 'Skyhawk Bombers..[2]'
echo 'SCUD Missle......[3]'
echo 'Dirty Bomb.......[4]'
echo ''
read WEAPON

echo ''
echo -n 'Continue? [y/N] '
read GO
case $GO in
	y | Y)
	echo 'Preparing to launch attack...'
	progress_bar.sh $(($MAXTIME*$RANDOM/32767)) $(($MAXSTEPS*$RANDOM/32767))
	sleep 2
	echo '[ERROR] Power Grid Failure.'
	sleep 1
	echo 'Continuing Attack anyhow.'
	sleep 2
	echo "error: on line 556. Syntax error near 'AND IF(login!=root) DIE //I need to fix this line at a later date, when I learn some more SQL. I know what I want it to do, but for the life of me I can't find it in the SQL manual. Oh well. This application is not throughly tested anyhow. DO NOT USE FOR PRODUCTION. meh';"
	sleep 3
	echo 'Attack aborted.'
	echo '221 2.0.0 Bye'
	echo 'Connection closed by foreign host.'
	exit 0;;

	*)
	echo 'Attack aborted.'
	echo '221 2.0.0 Bye'
	echo 'Connection closed by foreign host.'
	exit 0;;
esac
