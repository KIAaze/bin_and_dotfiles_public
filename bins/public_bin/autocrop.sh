#!/bin/bash
set -eu

for infile in "$@"
do
  extension="${infile##*.}"
  filename="${infile%.*}"
  outfile="${filename}.cropped.${extension}"
  echo "${infile} -> ${outfile}"
  #if test -e ${outfile}
  #then
    #echo "${outfile} exists. Overwrite? (y/n/a)"
    #read ans
    #if test ${ans} != 'y' && test ${ans} != 'a'
    #then
      #continue
    #fi
  #fi
  convert -trim +repage "${infile}" "${outfile}"
  convert -resize 383x693 -density 120x120 -units pixelspercentimeter "${outfile}" "${filename}.cropped.resized.${extension}"
done
