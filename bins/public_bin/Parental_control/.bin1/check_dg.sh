#!/bin/sh
## Look up what it is running

function check {
## DansGuardian
pid_dg="`pidof dansguardian | tr -d [:space:]`"
if (test -z $pid_dg);
then dg_running="" && echo "DansGuardian is stopped";
else dg_running="1" && echo "DansGuardian is running";
fi
if (test -z $dg_running);
then echo "Stopped" > /tmp/result;
else echo "Running" > /tmp/result;
fi
}

check
