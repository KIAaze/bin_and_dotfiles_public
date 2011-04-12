#!/bin/sh
## Look up what it is running

function check {
## FireHol
if (test -f /var/lock/firehol);
then fh_running="1" && echo "FireHol is running";
else fh_running="" && echo "FireHol is stopped";
fi
if (test -z $fh_running);
then echo "Stopped" > /tmp/result;
else echo "Running" > /tmp/result;
fi
}

check
