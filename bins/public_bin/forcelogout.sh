#!/bin/bash
# Check if all parameters are present
# If no, exit
set -e -u

SCRIPTS_PATH=$HOME/bin

mkdir -p $HOME/.kde/Autostart
mkdir -p $HOME/.config/autostart
mkdir -p $HOME/.config/openbox

usage()
{
        echo "usage :"
        echo "`basename $0` on HH:MM DD.MM.YY"
        echo "`basename $0` on HH:MM"
        echo "`basename $0` force-on HH:MM DD.MM.YY"
        echo "`basename $0` force-on HH:MM"
        echo "`basename $0` off"
        echo "`basename $0` on"
        exit 0
}

schedule_off_time()
{
	CMD="$SCRIPTS_PATH/forcelogout.sh off"
	echo "$CMD" | at $TIME $DATE
}

activate()
{
	echo "$SCRIPTS_PATH/logout.sh" >> $HOME/.config/openbox/autostart.sh
	echo "$SCRIPTS_PATH/logout.sh" >> $HOME/.bash_local
	ln -sf $SCRIPTS_PATH/logout.sh $HOME/.kde/Autostart/logout.sh
	ln -sf $SCRIPTS_PATH/logout.sh $HOME/.config/autostart/logout.sh
	cp -v $SCRIPTS_PATH/logout.sh.desktop $HOME/.config/autostart/

	echo "Stay out!" >$HOME/status
}

deactivate()
{
	sed -i.bak '/logout.sh/d' $HOME/.config/openbox/autostart.sh
	sed -i.bak '/logout.sh/d' $HOME/.bash_local
	rm -fv $HOME/.kde/Autostart/logout.sh
	rm -fv $HOME/.config/autostart/logout.sh
	rm -fv $HOME/.config/autostart/logout.sh.desktop

	echo "Welcome back!" >$HOME/status
}

# TODO: Improve argument handling
if [ $# -eq 2 ] && [ $1 = 'on' ]
then
	echo "ON"
	TIME=$2
	DATE=""
	echo "Login will be disabled until $TIME $DATE. Proceed?"
	read ans
	case $ans in
	y|Y|yes) schedule_off_time; activate;;
	*) exit 0;;
	esac
	exit 0
fi

if [ $# -eq 3 ] && [ $1 = 'on' ]
then
	echo "ON"
	TIME=$2
	DATE=$3
	echo "Login will be disabled until $TIME $DATE. Proceed?"
	read ans
	case $ans in
	y|Y|yes) schedule_off_time; activate;;
	*) exit 0;;
	esac
	exit 0
fi

if [ $# -eq 2 ] && [ $1 = 'force-on' ]
then
	echo "ON"
	TIME=$2
	DATE=""
	echo "Login will be disabled until $TIME $DATE."
	schedule_off_time
	activate
	exit 0
fi

if [ $# -eq 3 ] && [ $1 = 'force-on' ]
then
	echo "ON"
	TIME=$2
	DATE=$3
	echo "Login will be disabled until $TIME $DATE."
	schedule_off_time
	activate
	exit 0
fi

if [ $# -eq 1 ] && [ $1 = 'off' ]
then
	echo "OFF"
	deactivate
	exit 0
fi

if [ $# -eq 1 ] && [ $1 = 'on' ]
then
	echo "ON"
	activate
	exit 0
fi

usage
