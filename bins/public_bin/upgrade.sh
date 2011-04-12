#!/bin/bash

upgrade()
{
    PATH="$PATH:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

    echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" >> ~/logs/updatelog 
    date >> ~/logs/updatelog
    echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *" >> ~/logs/updatelog
    echo "" >> ~/logs/updatelog
    no | sudo apt-get upgrade >> ~/logs/updatelog 2>&1
    sudo apt-get upgrade
    echo "" >> ~/logs/updatelog
}

sudo apt-get clean
sudo apt-get update
no | sudo apt-get upgrade
df -h /

~/bin/say.sh "Source update finished. Waiting for upgrade confirmation."
echo "upgrade?"
read ans
case $ans in
        y|Y|yes) upgrade;;
esac
~/bin/finished.sh
