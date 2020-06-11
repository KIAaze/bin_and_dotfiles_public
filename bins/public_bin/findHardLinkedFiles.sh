#!/bin/bash

# Searches for "hard linked duplicates" and then offers to delete them interactively.
# Stops once there is only one file of each duplicate group left, even if it might still have hard-linked duplicates outside of the searched directory.
#
# Usage:
#   findHardLinkedFiles.sh DIR REM
#   if REM=1, interactively delete files, else just list them
#
# Example usage:
#   findHardLinkedFiles.sh .
#   findHardLinkedFiles.sh . 0
#   findHardLinkedFiles.sh . 1
#   findHardLinkedFiles.sh . 0 -maxdepth 3

DIR=${1:-.}
shift
REM=${1:-0}
shift
FINDOPTS=${@:-""}

echo "--> Using DIR = ${DIR}"
echo "--> Using REM = ${REM}"
echo "--> Using FINDOPTS = ${FINDOPTS}"

INODE_LIST=$(find ${DIR} ${FINDOPTS} -type f -links +1 -printf "%i\n" | sort -n | uniq --repeated)
for inode in ${INODE_LIST}
do
  echo "--- inode = ${inode} ---"
  
  # create file list
  FILE_LIST=()
  while IFS=  read -r -d $'\0'; do
      FILE_LIST+=("$REPLY")
  done < <(find ${DIR} ${FINDOPTS} -inum ${inode} -print0)
  
  # display files
  for f in "${FILE_LIST[@]}"
  do
    echo "${f}"
  done

  # print stats
  Nfiles=${#FILE_LIST[@]}
  Nlinks=$(stat --printf="%h" "${FILE_LIST[0]}")
  Nfiles_other=$((Nlinks - Nfiles))
  Nlinks_min=$((Nfiles_other + 1))
  echo "Nlinks=${Nlinks} = Nfiles=${Nfiles} here + Nfiles_other=${Nfiles_other} elsewhere. -> Nlinks_min=${Nlinks_min}"
  
  # remove files interactively
  if test ${REM} -eq 1
  then
    for f in "${FILE_LIST[@]}"
    do
      Nlinks=$(stat --printf="%h" "${f}")
      echo "Nlinks=${Nlinks} links left. Nlinks_min=${Nlinks_min}."
      if test ${Nlinks} -gt ${Nlinks_min}
      then
        rm -iv "${f}"
      fi
    done  
  fi

done

# define original and duplicates
#ORIG=("${FILE_LIST[0]}")
#DUPS=("${FILE_LIST[@]:1}")

#echo "-> Original:"
#echo ${ORIG}

#echo "-> Duplicates:"
##echo ${DUPS}

#for f in "${DUPS[@]}"
#do
  #echo "${f}"
#done
#rm -iv "${DUPS[@]}"

#echo ${FILE_LIST[0]}
#DUPS=("{$A[@]:1}")

#for f in "${FILE_LIST[@]:1}"
#do
  #echo ${f}
#done
#rm -iv ${FILE_LIST[@]:1}
