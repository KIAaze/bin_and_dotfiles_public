#!/bin/bash
set -eux

remove_extension()
{
  if find . -type f -iname "$1"
  then
    echo "Remove?"
    read ans
    if [ $ans = "y" ]
    then
      find . -type f -iname "$1" -exec rm -v {} \;
    fi
  fi
}

remove_extension "*.o"
remove_extension "*.obj"
remove_extension "tunnellicht*.exe"
remove_extension "SetupTunnelLicht*.exe"
remove_extension "tunnellicht"
remove_extension "moc_*"

find . -iname "*.rar"
find . -iname "*.tar.gz"
