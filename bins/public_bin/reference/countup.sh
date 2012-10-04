#!/bin/bash
countup()
{
	X=0
	while [ $X -lt 101 ]
	do
	echo $X
	sleep 1
	X=`expr $X + 1`
	done
}

countup | whiptail --gauge hihi 10 30 100
