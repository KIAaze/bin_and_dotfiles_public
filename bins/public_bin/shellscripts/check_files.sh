#!/bin/sh
#This shellscript checks if the files *index.root with index varying from arg1 to arg2 exist

# Check if all parameters are present
# If no, exit

if [ $# -ne 2 ]
then
	echo
	echo 'usage :'
	echo 'check_files.sh start_index end_index'
	echo
	exit 0 
fi

cd /s/$USER_flast/data
for (( i = $1 ; i <= $2 ; i++ ))
    do	  
	  filename=`filename_generator "Jpsi.auau.25gev.centr.mc." $i ".root"`
	  if [ ! -f $filename ];
	  then
	  echo "$filename does not exist.";
	  fi
          
	  filename=`filename_generator "Jpsi.auau.25gev.centr.params." $i ".root"`
	  if [ ! -f $filename ];
	  then
	  echo "$filename does not exist.";
	  fi
          
	  filename=`filename_generator "noJpsi.auau.25gev.centr.mc." $i ".root"`
	  if [ ! -f $filename ];
	  then
	  echo "$filename does not exist.";
	  fi
          
	  filename=`filename_generator "noJpsi.auau.25gev.centr.params." $i ".root"`
	  if [ ! -f $filename ];
	  then
	  echo "$filename does not exist.";
	  fi
    done
