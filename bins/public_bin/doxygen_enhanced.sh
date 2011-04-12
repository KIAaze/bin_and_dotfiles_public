#!/bin/bash
doxygen $1
echo "===>first warnings:"
head doxygen.log

#set -x
REMAINING=$(wc -l doxygen.log | awk '{print $1}')
TOTAL=682
# COMPLETED=$(bashcalc.sh 100 - \( 100 \* \( $REMAINING / $TOTAL \) \) )
COMPLETED=$(python -c "print 100. - ( 100. * ( $REMAINING. / $TOTAL. ) )")

echo "REMAINING=$REMAINING"
echo "TOTAL=$TOTAL"
echo "===>Documented: $COMPLETED%"

# find out which file has the most undocumented stuff
echo "===>Files sorted by undocumented stuff:"
awk -F: '{ print $1 }' ./doxygen.log >files.log
uniq -c ./files.log | sort
