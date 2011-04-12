#! /bin/bash
for f in *.jpg;
do
	base=`basename $f .jpg`
	echo "$f->$base.eps"
	convert $f $base.eps
done

