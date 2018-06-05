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
  
  # [3.1917, 5.7750] cm
  #convert -resize 383x693 -density 120x120 -units pixelspercentimeter -background white -gravity center -extent 383x693 "${outfile}" "${filename}.cropped.3.1917x5.7750.${extension}"
  # [4, 4] cm
  #convert -resize 480x480 -density 120x120 -units pixelspercentimeter -background white -gravity center -extent 480x480 "${outfile}" "${filename}.cropped.4x4.${extension}"
  # 4.375x4.375 cm
  convert -resize 525x525 -density 120x120 -units pixelspercentimeter -background white -gravity center -extent 525x525 "${outfile}" "${filename}.cropped.4.375x4.375.${extension}"
  # [5, 5] cm
  #convert -resize 600x600 -density 120x120 -units pixelspercentimeter -background white -gravity center -extent 600x600 "${outfile}" "${filename}.cropped.5x5.${extension}"
done
