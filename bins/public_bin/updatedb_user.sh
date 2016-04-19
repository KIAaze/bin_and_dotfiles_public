#!/bin/bash

# Create a locate database named $(basename $DIR).locate.db for each passed $DIR.

# from man locate:
# EXAMPLES
#        To create a private mlocate database as an user other than root, run
#               updatedb --require-visibility 0 --output db_file --database-root source_directory
#        Note that all users that can read *db_file* can get the complete list of files in the subtree of *source_directory*.

if [ $# -lt 1 ]
then
  echo "Create a locate database named \$(basename \$DIR).locate.db for each passed \$DIR."
  echo "Usage :"
  echo "  $(basename $0) DIR1 DIR2 ..."
  exit 0
fi

yestoall=false

for source_directory in "$@"
do
  if ! test -d ${source_directory}
  then
    echo "${source_directory} does not exist or is not a valid directory. Skipping..."
    continue
  fi
  
  if test ${source_directory} = "/"
  then
    db_file="root_and_media.locate.db"
  else
    db_file=$(basename ${source_directory}).locate.db
  fi
  echo "==> Creating ${db_file} from ${source_directory}"
  if ( ! ${yestoall} ) && ([ -e ${db_file} ])
  then
    echo "${db_file} exists. Overwrite? (y:yes, n:no, a:yes to all, q:quit)"
    read ans
    case $ans in
      y|Y|yes) echo "Proceeding...";;
      n|N|no) echo "Skipping..."; continue;;
      a|A|all) echo "Disabling confirmation..."; yestoall=true; continue;;
      *) echo "Quitting..."; exit;;
    esac
  fi
  updatedb --prunepaths="/tmp /var/spool /home/.ecryptfs" --require-visibility 0 --database-root ${source_directory} --output ${db_file}
  df -h ${source_directory} | tee ${db_file%.locate.db}.df.log
done
