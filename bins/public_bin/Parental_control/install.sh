#!/bin/bash
# License GPL, see LICENSE
# Written by Nanomad [condellog_At_gmail_dot_com]
if `gnome-terminal -e ./zenity_check`;
then zenity --info --title "Ubuntu Parental Control setup" --text $"This will install and configure a basic parental control feature for Ubuntu" && gksudo -t "Ubuntu Parental Contro setup" 'gnome-terminal -e ./.setup';
else exit 1;
fi
