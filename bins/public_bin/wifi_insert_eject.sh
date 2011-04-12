#!/bin/bash
# CARDON=$(lspci | grep -c Atheros)
#returns 0 if on
CARDON=$(pccardctl status | grep -c 'no card')
if [ $CARDON -eq 0 ]
then
	zenity --question --text "CARD ON: Do you want to turn it off?" && gksudo -m "Turn PCMCIA card off" pccardctl eject 0
else
	zenity --question --text "CARD OFF: Do you want to turn it on?" && gksudo -m "Turn PCMCIA card on" pccardctl insert 0
fi
