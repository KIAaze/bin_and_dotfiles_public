#!/bin/bash

AP=**********
KEY=************
IFACE=ath0/wifi0

sudo ifconfig $IFACE up
iwlist $IFACE scanning
sudo iwconfig $IFACE essid $AP key s:$KEY
sudo dhclient
ping www.google.com
