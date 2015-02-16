#!/bin/bash

# EXAMPLES
#        To create a private mlocate database as an user other than root, run
#               updatedb --require-visibility 0 --output db_file --database-root source_directory
#        Note that all users that can read *db_file* can get the complete list of files in the subtree of *source_directory*.

for source_directory in "$@"
do
  db_file=$(basename ${source_directory}).locate.db
  echo "==> Creating ${db_file} from ${source_directory}"
  if [ -e ${db_file} ]
  then
    echo "${db_file} exists. Overwrite?"
    read ans
    case $ans in
      y|Y|yes) echo "Proceeding...";;
      *) echo "skipping..."; return;;
    esac
  fi
  updatedb --require-visibility 0 --output ${db_file} --database-root ${source_directory}
done
