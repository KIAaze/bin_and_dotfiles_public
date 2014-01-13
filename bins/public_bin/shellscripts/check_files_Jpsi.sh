#!/bin/sh
#This shellscript checks if the files *index.root with index varying from arg1 to arg2 exist

# Check if all parameters are present
# If no, exit

if [ $# -ne 3 ]
then
	echo
	echo 'usage :'
	echo 'check_files.sh start_index end_index type(0=.mc.,1=.sts_reco.,2=.much_reco.)'
	echo
	exit 0 
fi

if [ $3 -eq 0 ]
then
  echo 'checking .mc. files';
  cd /s/$USER_flast/data_Jpsi
  for (( i = $1 ; i <= $2 ; i++ ))
      do	  
            filename=`filename_generator "Pluto.Urqmd.auau.25gev.centr.mc." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
            
            filename=`filename_generator "noPluto.Urqmd.auau.25gev.centr.mc." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
            
            filename=`filename_generator "Pluto.noUrqmd.auau.25gev.centr.mc." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
            
            filename=`filename_generator "Pluto.Urqmd.auau.25gev.centr.params." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
            
            filename=`filename_generator "noPluto.Urqmd.auau.25gev.centr.params." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
            
            filename=`filename_generator "Pluto.noUrqmd.auau.25gev.centr.params." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
      done
fi

if [ $3 -eq 1 ]
then
  echo 'checking .sts_reco. files';
  cd /s/$USER_flast/data_Jpsi
  for (( i = $1 ; i <= $2 ; i++ ))
      do	  
            filename=`filename_generator "Pluto.Urqmd.auau.25gev.centr.sts_reco." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
            
            filename=`filename_generator "noPluto.Urqmd.auau.25gev.centr.sts_reco." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
            
            filename=`filename_generator "Pluto.noUrqmd.auau.25gev.centr.sts_reco." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
      done
fi

if [ $3 -eq 2 ]
then
  echo 'checking .much_reco. files';
  cd /s/$USER_flast/data_Jpsi
  for (( i = $1 ; i <= $2 ; i++ ))
      do	  
            filename=`filename_generator "Pluto.Urqmd.auau.25gev.centr.much_reco." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
            
            filename=`filename_generator "noPluto.Urqmd.auau.25gev.centr.much_reco." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
            
            filename=`filename_generator "Pluto.noUrqmd.auau.25gev.centr.much_reco." $i ".root"`
            if [ ! -f $filename ];
            then
            echo "$filename does not exist.";
            fi
      done
fi
