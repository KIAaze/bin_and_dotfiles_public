#
#
# Linux Shell Scripting Tutorial (LSST) v1.05, March 2001
# Author: Vivek G Gite
#
# Run as:
# $ chmod  755  demom
# $ ./demom
#

##############
#small addition by me to show off underlined text too.
#And also that:
# \e is equivalent to \033. ;)
#\e[m is equivalent to \e[0m
#note: Bold apparently not possible with colors :(
echo -e "\033[4m underlined :)"
echo -e "\033[0m Normal"
echo -e "\e[4m underlined :)"
echo -e "\e[m Normal"
echo -e "\e[1;4;45mBold colors? Black text with colored background ok.\e[m"
echo -e "\e[4;34;45mNon bold color test: OK\e[m"
echo -e "\e[1;4;34;45mBold colors? Colored text not ok. :(\e[m"
##############

echo -e "\033[1m BOLD"
echo -e "\033[7m Background White Forground Black(reverse video)" 
echo -e "\033[5m Blink"
 
echo -e "\033[0m Normal"

echo  "30-37 Forground Color value as follows"
echo -e "\033[30m 30 - BLACK (Can U See?-)"
echo -e "\033[31;43m 31 - Red "
echo -e "\033[32m 32 - Green"
echo -e "\033[33m 33 - Brown"
echo -e "\033[34m 34 - Blue"
echo -e "\033[35m 35 - Magenta"
echo -e "\033[36m 36 - Cyan"
echo -e "\033[37m 37 - Gray"

echo -e "\033[38m Dark Gray"
echo -e "\033[39m Bright Red"
echo "40-47 Specifyes background Color value as follows (With default forgound color value)"

echo -e "\033[42m 42 - WOW!!!"

echo -e "\033[44m 44 - WOW!!!"

echo -e "\033[45m 45 - WOW!!!"

echo -e "\033[49m Back to Original (Use deafault background color)"
