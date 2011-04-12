#/bin/bash

echo $LINENO
echo $LINENO
echo $LINENO
exit

kill_1=0
kill_2=0

if [ $kill_1 -eq 1 ] || [ $kill_2 -eq 1 ]
then
echo "OK"
else
echo "not OK"
fi

echo "infobox start"
zenity --info --text "blabla" ||
zenity --info --text "blabla" ||
zenity --info --text "blabla" &
echo "infobox finished"

var1=$(grep 'All OK' toto.txt | wc -l)
var2=$(grep toto toto.txt | wc -l)
if test $var1 -eq 1
then
echo "all is ok";
else
echo "all is NOT ok";
exit -1;
fi
if test $var2 -eq 1
then
echo "toto is there";
else
echo "toto is NOT there";
exit -1;
fi

i=18
echo toto$i\youpi
echo "toto$1"
echo "toto$1hihi"
echo $2
#rm -i toto$i[*]
# | rm -i
for (( i = $1 ; i <= $2 ; i++ ))
    do
	if [ $i -gt 9 ]
	then
		echo "index=$i";
	else
		echo "index=0$i";
	fi
    done
