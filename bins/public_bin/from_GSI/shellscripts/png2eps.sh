#! /bin/bash
for f in *.png;
do
	base=`basename $f .png`
	echo "$f->$base.eps"
	convert $f $base.eps
done

