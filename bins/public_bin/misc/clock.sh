#!/bin/bash
#
# Linux Shell Scripting Tutorial 1.05r3, Summer-2002
#
# Written by Vivek G. Gite <vivek@nixcraft.com>
#
# Latest version can be found at http://www.nixcraft.com/
#
# Q17
# To run type at $ promot as
# $ q17 &
#

echo 
echo "Digital Clock for Linux"
echo "To stop this clock use command kill pid, see above for pid"
echo "Press a key to continue. . ."

while :
do
    ti=`date +"%r"`      
    echo -e -n "\033[7s"    #save current screen postion & attributes
    #
    # Show the clock
    #
    
    tput cup 0 69          # row 0 and column 69 is used to show clock
    
    echo -n $ti            # put clock on screen
     
    echo -e -n "\033[8u"   #restore current screen postion & attributs
    #
    #Delay fro 1 second
    #
    sleep 1
done





#
# ./ch.sh: vivek-tech.com to nixcraft.com reference converted using this tool
# See the tool at http://www.nixcraft.com/uniqlinuxfeatures/tools/
#
