#!/bin/sh
## Look up what it is running

function check {
## TinyProxy
pid_tp="`pidof tinyproxy | tr -d [:space:]`"
if (test -z $pid_tp);
then tp_running="" && echo "TinyProxy is stopped"; 
else tp_running="1" && echo "TinyProxy is running";
fi
if (test -z $tp_running);
then echo "Stopped" > /tmp/result;
else echo "Running" > /tmp/result;
fi
}

check

