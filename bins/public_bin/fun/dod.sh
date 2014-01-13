#!/bin/bash
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
echo 'Which country would you like to attack?'
echo 'Loading Countries...'
touch countries
bar.sh -E -c 'mv countries country && sleep 1 && mv country nation && sleep 1 && mv nation attack && sleep 1 && mv attack countries'

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
bar.sh -E -c 'mv countries country && sleep 1 && mv country nation && sleep 1 && mv nation attack && sleep 1 && mv attack countries'
echo ''
echo 'Please choose your prefered method of destruction:'
echo 'Loading weapons...'
bar.sh -E -c 'mv countries country && sleep 1 && mv country nation && sleep 1 && mv nation attack && sleep 1 && mv attack countries'

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
	bar.sh -E -c 'mv countries country && sleep 2 && mv country nation && sleep 1 && mv nation attack && sleep 1 && mv attack countries'
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
	rm countries
	exit 0;;

	n | N)
	echo 'Attack aborted.'
	echo '221 2.0.0 Bye'
	echo 'Connection closed by foreign host.'
	rm countries
	exit 0;;
esac

