#!/bin/bash
# remove .o and .obj files (practical if make clean/distclean is not available)

find . -type f \( -name "*.o" -o -name "*.obj" \) | less

echo "Remove those object files? (y=directly, i=interactively, *=exit)"
read ans
case $ans in
  y|Y|yes) find . -type f \( -name "*.o" -o -name "*.obj" \) -exec rm -v {} \; ;;
  i|I)     find . -type f \( -name "*.o" -o -name "*.obj" \) -exec rm -iv {} \; ;;
  *)       exit 1;;
esac
