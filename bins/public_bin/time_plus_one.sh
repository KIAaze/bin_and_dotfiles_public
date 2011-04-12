#!/bin/bash
hour=`date +%H`
hour=`expr $hour + 1`
minute=`date +%M`

echo $hour:$minute
