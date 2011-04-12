#!/bin/bash
set -eux

replace_safely()
{
  SRC=/root/certificate/server.pem
  DST=$1
  datefull=$(date +%Y%m%d_%H%M%S)
  cp -iv $DST $DST.$datefull
  cp -iv $SRC $DST
}

replace_safely /usr/share/courier-imap/pop3d.pem
replace_safely /usr/share/courier-imap/imapd.pem
replace_safely /var/qmail/control/servercert.pem

service courier-imap restart
service qmail restart
