#!/bin/bash

# TODO: Create new directory? Pythonify? srcdir -> dstdir for batch processing

# usage:
#   imagemagick-resize.sh PERCENTAGE FILE1 FILE2...
# example usage:
#   imagemagick-resize.sh 15 $(find . -name "*.JPG")

set -eu

N=${1}
shift

DSTDIR=$(mktemp --directory)

echo "=================="
echo "DSTDIR = ${DSTDIR}"
echo "=================="

for infile in "$@"
do
  filename_base=$(basename "${infile}")
  filename_dir=$(dirname "${infile}")
  extension="${filename_base##*.}"
  filename="${filename_base%.*}"
  outfile=${DSTDIR}/${filename_dir}/${filename}-resized-${N}%.${extension}
  mkdir --parents ${DSTDIR}/${filename_dir}
  echo "${infile} -> ${outfile}"
  if test -e ${outfile}
  then
    echo "${outfile} already exists. Overwrite? (y/n)"
    read ans
    if [[ ${ans} != "y" ]]
    then
      echo "Skipping ${outfile}"
      continue
    fi
  fi
  convert ${infile} -resize ${N}% ${outfile}
done

echo "=================="
echo "DSTDIR = ${DSTDIR}"
du -sh ${DSTDIR}
echo "=================="
