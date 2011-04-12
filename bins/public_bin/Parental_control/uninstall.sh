#!/bin/bash
# License GPL, see LICENSE
# Written by Nanomad [condellog_At_gmail_dot_com]
if `gnome-terminal -e ./zenity_check`;
then zenity --info --title "Ubuntu Parental Control setup" --text $"This wil REMOVE the  parental control feature for Ubuntu" && gksudo -t "Ubuntu Parental Contro setup" 'gnome-terminal -e ./.remove';
else exit 1;
fi
