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

function stop {
## stops what it is not running
## Firehol
if (test -z $fh_running);
then echo "FireHol already stopped";
else gksudo /etc/init.d/firehol stop;
fi

## TinyProxy
if (test -z $tp_running);
then echo "TinyProxy already stopped";
else gksudo /etc/init.d/tinyproxy stop;
fi

## DansGuardian
if (test -z $dg_running);
then echo "DansGuardian already stopped";
else gksudo /etc/init.d/dansguardian stop;
fi
}

function stopcheck {
if (test -z $fh_running) && (test -z $tp_running) && (test -z $dg_running);
then echo "All OK! Everything was stopped" > /tmp/result;
else echo "There was an error" > /tmp/result;
fi
}

check
stop
check
stopcheck
