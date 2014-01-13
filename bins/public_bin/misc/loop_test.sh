#This shellscript run much_sim.C(nEvents,index) with index varying from arg1 to arg2
rm toto.out toto.err
for (( i = $1 ; i <= $2 ; i++ ))
    do
          echo "index=$i"
	  root -l -q .x "toto.C($i)" 1>>toto.out 2>>toto.err
    done
