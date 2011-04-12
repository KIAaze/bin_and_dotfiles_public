#!/usr/bin/env python
#doxygen
#head doxygen.log

REMAINING=$(wc -l doxygen.log | awk '{print $1}')
TOTAL=801
COMPLETED=$(bashcalc.sh 100 - \( 100 \* \( $REMAINING / $TOTAL \) \) )

echo "Documented: $COMPLETED%"
