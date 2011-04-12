for file in Jpsi.*
do
   newname=`echo $file | sed -e 's/Jpsi/Pluto.Urqmd/'`
   mv $file $newname
done
