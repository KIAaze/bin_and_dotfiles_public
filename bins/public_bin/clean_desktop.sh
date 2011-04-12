#! /bin/bash
# DATE=$(date +%d%m%Y)
DATE=$(date +%Y%m%d)
FOLDER=desktop_$DATE
mkdir ~/$FOLDER
if [ $? -eq 0 ]
then
	echo "mv -v ~/Desktop/* ~/$FOLDER"
	mv -v ~/Desktop/* ~/$FOLDER

	zenity --info --text "Desktop contents moved to $FOLDER." ||
	kdialog --msgbox "Desktop contents moved to $FOLDER." ||
	xmessage -buttons okay -default okay "Desktop contents moved to $FOLDER."
else
	zenity --info --text "Desktop contents not cleaned up because a $FOLDER already exists." ||
	kdialog --msgbox "Desktop contents not cleaned up because a $FOLDER already exists." ||
	xmessage -buttons okay -default okay "Desktop contents not cleaned up because a $FOLDER already exists."
fi
