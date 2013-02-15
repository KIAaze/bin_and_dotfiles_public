#!/bin/bash
#
# Script to move multiple files in lots of subfolders into a single folder, renaming them automatically as necessary.
#
# Acts like standard move, except that if a file with the same name exists at the destination, it automatically renames the source file by adding "_#".
# MEANT FOR SINGLE FILE MOVES ONLY!!!!

# Alternate solution to this script:
# mv --backup=numbered src/* ./dst/

# set -eux
set -eu

usage()
{
  echo "usage :"
  echo "`basename $0` FORMAT SRC DESTDIR"
  echo 
  echo "FORMAT=0: \$DESTDIR/\$(basename "\$SRC")_\$COUNTER"
  echo "FORMAT=1: \$DESTDIR/\$(basename "\$SRC" .\$EXTENSION).\$COUNTER.\$EXTENSION"
  echo 
  echo "Acts like standard move, except that if a file with the same name exists at the destination, it automatically renames the source file by adding "_#"."
  echo "MEANT FOR SINGLE FILE MOVES ONLY!!!!"
  echo 
  echo "filename=\$(basename \$fullfile)"
  echo "extension=\${filename##*.}"
  echo "filename=\${filename%.*}"
  exit 0
}

smartmove()
{
  FORMAT=$1
  SRC="$2"
  DESTDIR="$3"

  if ! test -d "$DESTDIR"
  then
	  echo "ERROR: $DESTDIR does not exist or is not a directory"
	  exit 1
  fi

  if ! test -s "$SRC"
  then
	  if ! test -e "$SRC"
	  then
	    echo "WARNING: $SRC does not exist."
# 	    exit 1
	  else
	    echo "WARNING: $SRC is empty."
# 	    rm -iv "$SRC"
	  fi
  fi

  if test -e "$SRC"
  then
    ########################################
    # get fileparts
    DIRNAME=$(dirname "$SRC")
    FILENAME=$(basename "$SRC")
    EXTENSION=.${FILENAME##*.}
    BASENAME=${FILENAME%.*}

    if [ ".$BASENAME" = "$EXTENSION" ]
    then
      EXTENSION="";
    fi

    echo "DIRNAME = $DIRNAME"
    echo "FILENAME = $FILENAME"
    echo "EXTENSION = $EXTENSION"
    echo "BASENAME = $BASENAME"
    ########################################

    if [ $FORMAT -eq 0 ]
    then
      ADDON=""
      OUTFILE="$DESTDIR/$FILENAME$ADDON"
      COUNTER=0
      while test -e "$OUTFILE"
      do
	      echo "$OUTFILE exists"
	      ADDON="_$COUNTER"
	      echo "ADDON=$ADDON"
	      COUNTER=`expr $COUNTER + 1`
	      OUTFILE="$DESTDIR/$FILENAME$ADDON"
      done
      echo "OUTFILE=$OUTFILE"

      mv -iv "$SRC" "$OUTFILE"
    else
      ADDON=""
      OUTFILE="$DESTDIR/$BASENAME$ADDON$EXTENSION"
      COUNTER=0
      while test -e "$OUTFILE"
      do
	      echo "$OUTFILE exists"
	      ADDON=".$COUNTER"
	      echo "ADDON=$ADDON"
	      COUNTER=`expr $COUNTER + 1`
	      OUTFILE="$DESTDIR/$BASENAME$ADDON$EXTENSION"
      done
      echo "OUTFILE=$OUTFILE"

      mv -iv "$SRC" "$OUTFILE"
    fi

  fi
}

if [ $# -lt 3 ]
then
  usage;
fi

FORMAT=$1
NUM=$(($#-2))
DESTDIR="${!#}"
echo "FORMAT = $FORMAT"
echo "NUM = $NUM"
echo "DESTDIR = $DESTDIR"

if [ "$FORMAT" != "0" ] && [ "$FORMAT" != "1" ]
then
  usage;
fi

# format read in, shift vars
shift

for (( index = 0 ; index < $NUM ; index++ ))
do
#         echo $FORMAT "$1" "$DESTDIR"
        smartmove $FORMAT "$1" "$DESTDIR"
	shift
done
