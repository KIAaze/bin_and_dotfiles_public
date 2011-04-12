#!/bin/bash
set -eu

DST="/cygdrive/j/optics/$USER_FirstL/newPillars"

echo "#!/bin/bash"
echo "DST=$DST"

for f in "$@"
do
	#echo "$f"
	DIR=$(dirname $(readlink -f $f))
	BASE=$(basename $DIR)
	LINKNAME=$DST/$BASE
	if ! [ -e $LINKNAME ]
	then
		if grep Deallocating  $f >/dev/null
		then
			echo "scp -r $USER_HOST_B@$HOST_B:$DIR \$DST"
		fi
	fi
done

