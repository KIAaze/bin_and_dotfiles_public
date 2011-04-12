#!/bin/sh
## Look up what it is running

function check {
## FireHol
if (test -f /var/lock/firehol);
then fh_running="1" && echo "FireHol is running";
else fh_running="" && echo "FireHol is stopped";
fi

## TinyProxy
pid_tp="`pidof tinyproxy | tr -d [:space:]`"
if (test -z $pid_tp);
then tp_running="" && echo "TinyProxy is stopped"; 
else tp_running="1" && echo "TinyProxy is running";
fi

## DansGuardian
pid_dg="`pidof dansguardian | tr -d [:space:]`"
if (test -z $pid_dg);
then dg_running="" && echo "DansGuardian is stopped";
else dg_running="1" && echo "DansGuardian is running";
fi
}

function start {
## Starts what it is not running
## Firehol
if (test -z $fh_running);
then gksudo /etc/init.d/firehol start;
else echo "FireHol already running";
fi

## TinyProxy
if (test -z $tp_running);
then gksudo /etc/init.d/tinyproxy start;
else echo "TinyProxy already running";
fi

## DansGuardian
if (test -z $dg_running);
then gksudo /etc/init.d/dansguardian start;
else echo "DansGuardian already running";
fi
} 

function startcheck {
if (test -z $fh_running) && (test -z $tp_running) && (test -z $dg_running);
then echo "There was an error" > /tmp/result;
else echo "All OK! Everything is running" > /tmp/result;
fi
}
check
start
check
startcheck
