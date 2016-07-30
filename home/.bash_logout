# ${HOME}/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

#if [ "$SHLVL" = 1 ]; then
#    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
#fi
 
# invalidate the gpm selection buffer iff logging out from a
# virtual terminal
if test -x /sbin/consoletype && /sbin/consoletype fg
then if test -r /var/run/gpm.pid && test -d "/proc/$(/bin/cat /var/run/gpm.pid)"
     then kill -USR2 "$(/bin/cat /var/run/gpm.pid)"
     fi
fi
 
#/usr/bin/clear

# "close sudo session" (only works if su --login is used, i.e. if exiting a login shell...)
sudo -k

echo "closed sudo session"
#sudo echo

#sleep 15
