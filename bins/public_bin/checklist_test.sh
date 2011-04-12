#!/usr/bin/env bash
# -zenity
# -kdialog
# -xdialog
# -whiptail

TITLE="Which actions should be executed?"
INFO="INFO"

OPTION_ARRAY=( \
"create_bash_engrid" \
"install_QT" \
"install_VTK" \
"install_CGNS" \
"build_engrid" \
"update_netgen" \
"update_engrid" \
"rebuild_engrid" \
"create_start_engrid" \
)

N_ITEMS=${#OPTION_ARRAY[@]}

for name in ${OPTION_ARRAY[@]}
do
echo $name
# other stuff on $name
done

# exit

ans=$(zenity  --height=350 --list  --text "$TITLE" --checklist  --column "Run" --column "Actions" \
FALSE "create_bash_engrid" \
FALSE "install_QT" \
FALSE "install_VTK" \
FALSE "install_CGNS" \
FALSE "build_engrid" \
FALSE "update_netgen" \
FALSE "update_engrid" \
FALSE "rebuild_engrid" \
FALSE "create_start_engrid" \
--separator=":");

dialog --backtitle "No Such Organization" \
	--title "$TITLE" \
        --checklist "$INFO" 20 61 $N_ITEMS \
        "Apple"  "" OFF \
        "Dog"    "" OFF \
        "Orange" "" OFF \
        "Chicken"    "" OFF \
        "Cat"    "" OFF \
        "Fish"   "" OFF \
        "Lemon"  "" OFF

kdialog --checklist "$TITLE" 1 "American English" off 2  French on 3 "Oz' English" off

whiptail --title "$TITLE" --checklist \
"$INFO" 20 78 $N_ITEMS \
"NET_OUTBOUND" "" OFF \
"NET_INBOUND" "" OFF \
"LOCAL_MOUNT" "" OFF \
"REMOTE_MOUNT" "" OFF

Xdialog --backtitle "No Such Organization" \
	--title "$TITLE" \
        --checklist "$INFO" 20 61 $N_ITEMS \
        "Apple"  "" OFF \
        "Dog"    "" OFF \
        "Orange" "" OFF \
        "Chicken"    "" OFF \
        "Cat"    "" OFF \
        "Fish"   "" OFF \
        "Lemon"  "" OFF
