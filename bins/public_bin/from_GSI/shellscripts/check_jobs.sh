#!/bin/sh
#This shellscript checks if the jobs *index with index varying from arg1 to arg2 exist

# Check if all parameters are present
# If no, exit
if [ $# -ne 3 ]
then
	echo
	echo 'usage :'
	echo 'check_jobs.sh start_index end_index type(0=SIM,1=STS,2=MUCH)'
	echo
	exit 0 
fi

# Create joblist.txt and check if connected to an lxi machine
# If no, exit
cd /s/$USER_flast/data
bjobs>joblist.txt
if [ $? -eq 0 ]
then
  echo "already connected to an lxi machine"
  echo "joblist.txt creation successful"
else
  echo "not connected to an lxi machine"
  echo "joblist.txt creation not successful"
  exit 0
fi

# Check the jobs
if [ $3 -eq 0 ]
then
  echo 'checking SIM jobs';
  for (( i = $1 ; i <= $2 ; i++ ))
      do
            jobname=SIM_01_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
            echo "$jobname does not exist.";
            fi
            
            jobname=SIM_10_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
            echo "$jobname does not exist.";
            fi
            
            jobname=SIM_11_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
            echo "$jobname does not exist.";
            fi
      done
fi

if [ $3 -eq 1 ]
then
  echo 'checking STS jobs';
  for (( i = $1 ; i <= $2 ; i++ ))
      do
            jobname=STS_01_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
            echo "$jobname does not exist.";
            fi
            
            jobname=STS_10_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
            echo "$jobname does not exist.";
            fi
            
            jobname=STS_11_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
            echo "$jobname does not exist.";
            fi
      done
fi

if [ $3 -eq 2 ]
then
  echo 'checking MUCH jobs';
  for (( i = $1 ; i <= $2 ; i++ ))
      do
            jobname=MUCH_01_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
            echo "$jobname does not exist.";
            fi
            
            jobname=MUCH_10_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
            echo "$jobname does not exist.";
            fi
            
            jobname=MUCH_11_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
            echo "$jobname does not exist.";
            fi
      done
fi
