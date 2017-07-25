#!/bin/bash
# source: https://stackoverflow.com/questions/1358920/measure-disk-space-of-certain-file-types-in-aggregate
find . -type f -printf "%f %s\n" |
  awk '{
      PARTSCOUNT=split( $1, FILEPARTS, "." );
      EXTENSION=PARTSCOUNT == 1 ? "NULL" : FILEPARTS[PARTSCOUNT];
      FILETYPE_MAP[EXTENSION]+=$2
    }
   END {
     for( FILETYPE in FILETYPE_MAP ) {
       print FILETYPE_MAP[FILETYPE], FILETYPE;
      }
   }' | sort -n
