#This shellscript runs much_sim.C(nEvents,index) with nEvents=arg1 and index varying from arg2 to arg3
#cd ~/cbmroot/macro/much/data
#rm -v *

# Check if all parameters are present
# If no, exit

if [ $# -ne 3 ]
then
	echo
	echo 'usage :'
	echo 'much_sim_looping.sh nEvents start_index end_index'
	echo
	exit 0 
fi

cd ~/cbmroot/macro/much
for (( i = $2 ; i <= $3 ; i++ ))
    do
          echo "index=$i: creating job_$i"
          #root -l -q .x "much_sim.C($1,$i)" > /dev/null 2>&1
	  bsub -J job_$i -u $EMAIL_GSI root -l -q .x "much_sim.C($1,$i)"
    done
