#! /bin/bash
ext=.png
pics=`find . -name "*$ext"`
#echo $pics
for p in $pics;
do
	dir=`dirname $p`
	base=`basename $p $ext`
	echo "$p->$dir/$base.x"
	#mv $p $dir/$basex
done
