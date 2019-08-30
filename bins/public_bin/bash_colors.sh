#!/bin/bash

# black="\e[0;38;5;0m"
# red="\e[0;38;5;1m"
# orange="\e[0;38;5;130m"
# green="\e[0;38;5;2m"
# yellow="\e[0;38;5;3m"
# blue="\e[0;38;5;4m"
# bblue="\e[0;38;5;12m"
# magenta="\e[0;38;5;55m"
# magenta2="\e[0;38;5;5m"
# cyan="\e[0;38;5;6m"
# white="\e[0;38;5;7m"
# coldblue="\e[0;38;5;33m"
# smoothblue="\e[0;38;5;111m"
# iceblue="\e[0;38;5;45m"
# turqoise="\e[0;38;5;50m"
# smoothgreen="\e[0;38;5;42m"
# brown="\e[0;38;5;3m"
# defaultcolor="\e[m"

source ${HOME}/bin/public_bin/library/colors.sh

# echo -e "${red}red ${green}green ${blue}blue ${defaultcolor}"

TABLE=1
if [[ ${TABLE} -eq 1 ]]
then
  FLAG="-n"
else
  FLAG=""
fi

for (( index = 0 ; index <= 255 ; index++ ))
do
  echo ${FLAG} -e "\e[0;38;5;${index}m$(printf %.3d ${index}) "
  if [[ ${index}%16 -eq 15 ]] && [[ ${TABLE} -eq 1 ]]
  then
    echo
  fi
done

echo
echo "Example usage:"
echo -n "echo -e \"\e[0;38;5;"
echo -e -n "${green}\${index}${defaultcolor}"
echo "mHello world.\e[m\""

echo -n "echo -e \"\e[0;38;5;"
echo -e -n "${green}42${defaultcolor}"
echo "mHello world.\e[m\""
echo
echo "Note: \033 is equivalent to \e."
