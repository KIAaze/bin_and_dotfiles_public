#This shellscript does the MUCH reconstruction with and without Jpsi for arg1 events with index varying from arg2 to arg3
#But only in case the corresponding MUCH job doesn't exist anymore and the output files don't exist yet.

# Check if all parameters are present
# If no, exit
if [ $# -ne 3 ]
then
	echo
	echo 'usage :'
	echo 'much_reconstruction.sh nEvents start_index end_index'
	echo
	exit 0 
fi

# Create joblist.txt and check if connected to an lxi machine
# If no, exit
cd /s/$USER_flast/data_Psi_prime
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

#create jobs
cd /s/$USER_flast/data_Psi_prime
for (( i = $2 ; i <= $3 ; i++ ))
	do

            jobname=Psi_prime_STS_01_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
              echo "$jobname does not exist.";
              filename=`filename_generator "noPluto.Urqmd.auau.25gev.centr.much_reco." $i ".root"`
              if [ ! -f $filename ];
              then
                      echo "$filename does not exist.";
                      echo "index=$i: creating Psi_prime_MUCH_01_$i";
                      bsub -J Psi_prime_MUCH_01_$i root -l -q .x "~/cbmroot/macro/much/much_reco_Psi_prime.C($1,$i,0,1)";
              fi            
            fi
            
            jobname=Psi_prime_STS_10_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
              echo "$jobname does not exist.";
                filename=`filename_generator "Pluto.noUrqmd.auau.25gev.centr.much_reco." $i ".root"`
                if [ ! -f $filename ];
                then
                        echo "$filename does not exist.";
                        echo "index=$i: creating Psi_prime_MUCH_10_$i";
                        bsub -J Psi_prime_MUCH_10_$i root -l -q .x "~/cbmroot/macro/much/much_reco_Psi_prime.C($1,$i,1,0)";
                fi
            fi
            
            jobname=Psi_prime_STS_11_$i
            if [ $(grep -c $jobname joblist.txt) -eq 0 ];
            then
              echo "$jobname does not exist.";
                filename=`filename_generator "Pluto.Urqmd.auau.25gev.centr.much_reco." $i ".root"`
                if [ ! -f $filename ];
                then
                        echo "$filename does not exist.";
                        echo "index=$i: creating Psi_prime_MUCH_11_$i";
                        bsub -J Psi_prime_MUCH_11_$i root -l -q .x "~/cbmroot/macro/much/much_reco_Psi_prime.C($1,$i,1,1)";
                fi            
            fi
done
