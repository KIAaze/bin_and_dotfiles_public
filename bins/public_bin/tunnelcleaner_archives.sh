#!/bin/bash
set -eux

remove_extension()
{
  find . -type f -iname "$1" -exec rm -v {} \;
#   if find . -type f -iname "$1"
#   then
#     echo "Remove?"
#     read ans
#     if [ $ans = "y" ]
#     then
#       find . -type f -iname "$1" -exec rm -v {} \;
#     fi
#   fi
}

clean_archive()
{
  ARCHIVE=$(readlink -f "$1")
  DIR=$(basename "$ARCHIVE" .tar.gz)
  mkdir "$DIR"
  cd "$DIR"
  tar -xzvf "$ARCHIVE" && rm -v "$ARCHIVE"
  remove_extension "*.o"
  remove_extension "*.obj"
  remove_extension "tunnellicht*.exe"
  remove_extension "SetupTunnelLicht*.exe"
  remove_extension "tunnellicht"
  remove_extension "moc_*"
  remove_extension "*.so"
  cd ..
  tar -czvf $ARCHIVE $DIR && rm -rf "$DIR"
}

for f in "$@"
do
  echo "Cleaning $f"
  clean_archive "$f"
done
