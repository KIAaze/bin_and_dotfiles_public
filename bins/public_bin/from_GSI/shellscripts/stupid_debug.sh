#! /bin/sh
awk '/^/ {print "cout<<\"IN  "FNR"\"<<endl;"; print; print "cout<<\"OUT "FNR"\"<<endl;"; next} {print}' $1
