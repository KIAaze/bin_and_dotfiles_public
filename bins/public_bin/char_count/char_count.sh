#!/bin/sed
#Print the number of characters on each line
#by Steve Ahrendt steve@xxxxxxxxxxxxx


#Make all the characters the same
s/./x/g

#Handle blank lines
s/^$/0 /g

#Group the characters by powers of ten
s/x\{100\}/100 /g
s/x\{10\}/10 /g
s/x/1 /g

#Add the hundreds
s/100 100 100 100 100 100 100 100 100 /900 /
s/100 100 100 100 100 100 100 100 /800 /
s/100 100 100 100 100 100 100 /700 /
s/100 100 100 100 100 100 /600 /
s/100 100 100 100 100 /500 /
s/100 100 100 100 /400 /
s/100 100 100 /300 /
s/100 100 /200 /

#Add the tens
s/10 10 10 10 10 10 10 10 10 /90 /
s/10 10 10 10 10 10 10 10 /80 /
s/10 10 10 10 10 10 10 /70 /
s/10 10 10 10 10 10 /60 /
s/10 10 10 10 10 /50 /
s/10 10 10 10 /40 /
s/10 10 10 /30 /
s/10 10 /20 /

#Add the ones
s/1 1 1 1 1 1 1 1 1 /9 /
s/1 1 1 1 1 1 1 1 /8 /
s/1 1 1 1 1 1 1 /7 /
s/1 1 1 1 1 1 /6 /
s/1 1 1 1 1 /5 /
s/1 1 1 1 /4 /
s/1 1 1 /3 /
s/1 1 /2 /

#Add the totals
s/0 \([0-9]\) /\1 /
s/00 \([0-9][0-9]\) /\1/

