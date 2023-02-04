#!/bin/bash
# script to apt upgrade kept back packages
sudo apt upgrade $(sudo apt-get upgrade | awk '/The following packages have been kept back:/{flag=1; next} /0 to upgrade/{flag=0} flag' | tr '\n' ' ')
