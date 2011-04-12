#! /bin/bash

# filename: replaceall
# Backup files are NOT saved in this script.
     find . -type f -name $3 -print | while read i
     do
     echo $i
        sed 's|$1|$2|g' $i > $i.tmp && mv $i.tmp $i
     done
     
# Check if all parameters are present
# If no, exit
# if [ $# -ne 3 ]
# then
#         echo
#         echo "usage :"
#         echo "$0 pattern1 pattern2 file"
#         echo
#         exit 0
# fi
# find $3 -type f
# find $3 -type f -exec sed -i 's/$1/$2/g' {} \;

