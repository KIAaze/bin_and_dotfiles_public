echo "WARNING:"
echo "This will uninstall cbmroot completely by deleting ALL files inside cbmroot, cbmroot2, cbmsoft and MyBuild32!"
echo "Do you wish to continue?"

read ans
case $ans in
  y|Y|yes);;
  *) echo Quitting
  exit 0;;
esac

echo "Deleting files..."

cd ~
rm -rf cbmroot cbmroot2 cbmsoft MyBuild_32

echo "Files deleted."
