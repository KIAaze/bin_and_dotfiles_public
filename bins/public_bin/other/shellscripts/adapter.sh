#! /bin/bash
#script to adapt all *Psi_prime* files into *Jpsi* files
for f in *Psi_prime.sh;
do
        base=`basename $f "Psi_prime.sh"`
        newname=`echo $base\Jpsi.sh`
        echo "$f -> $newname"
        sed s/Psi_prime/Jpsi/g $f >$newname

#         sed s/psi_SIM/Psi_prime_SIM/ $f >tmp; cp tmp $f
#         sed s/psi_STS/Psi_prime_STS/ $f >tmp; cp tmp $f
#         sed s/psi_MUCH/Psi_prime_MUCH/ $f >tmp; cp tmp $f
done

for f in *Psi_prime.C;
do
        base=`basename $f "Psi_prime.C"`
        newname=`echo $base\Jpsi.C`
        echo "$f -> $newname"
        sed s/Psi_prime/Jpsi/g $f >$newname

#         sed s/psi_SIM/Psi_prime_SIM/ $f >tmp; cp tmp $f
#         sed s/psi_STS/Psi_prime_STS/ $f >tmp; cp tmp $f
#         sed s/psi_MUCH/Psi_prime_MUCH/ $f >tmp; cp tmp $f
done
