#!/bin/bash
wget --directory-prefix=$HOME/Downloads http://urlblacklist.com/cgi-bin/commercialdownload.pl?type=download&file=bigblacklist
sudo tar --directory /etc/dansguardian/lists/ -xzvf bigblacklist.tar.gz
