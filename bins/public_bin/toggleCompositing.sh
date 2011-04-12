#!/bin/sh
RESULT=`qdbus org.kde.kwin /KWin org.kde.KWin.compositingActive`

if [ "$RESULT" = "true" ]
then
  # turn off
  kwriteconfig --file kwinrc --group Compositing --key Enabled false
else
  # turn on
  kwriteconfig --file kwinrc --group Compositing --key Enabled true
fi

# Then restart kwin (in Alt+F2) with:
kwin --replace &
