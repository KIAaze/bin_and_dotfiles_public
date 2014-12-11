echo "WARNING:"
echo "This will uninstall toto completely by deleting ALL files 
inside toto"
echo "Do you wish to continue?"

read ans
case $ans in
  y|Y|yes);;
  *) echo Quitting
  exit 0;;
esac

echo "Deleting files..."

cd ~
rm -rf toto

echo "Files deleted."

echo "you bastard! you killed toto!"
