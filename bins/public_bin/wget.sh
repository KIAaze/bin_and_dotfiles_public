#!/bin/bash

# script to wget URLs listed in a simple text file for offline use
# Usage:
#   wget.sh DSTDIR urls.txt

# --directory-prefix=prefix
# wget -E -H -k -K -p http://<site>/<document>
#        -E
#        --adjust-extension
# 
#        -H
#        --span-hosts
# 
#        -k
#        --convert-links
# 
#        -K
#        --backup-converted
# 
#        -p
#        --page-requisites

# TODO: pythonify for sanity...
# TODO: bash read doc??? -u, -r,...??? Best/safest way to loop through file???
# https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
# https://www.cyberciti.biz/faq/bash-loop-over-file/
# https://unix.stackexchange.com/questions/7011/how-to-loop-over-the-lines-of-a-file
# https://www.cyberciti.biz/faq/unix-howto-read-line-by-line-from-file/
# https://cmdlinetips.com/2018/04/how-to-loop-through-lines-in-a-file-in-bash/

set -u

# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
  echo "Script to wget URLs listed in a simple text file for offline use."
  echo "Usage :"
  echo "`basename $0` DSTDIR urls.txt"
  exit 0
fi

# export http_proxy='http://localhost:8080'
# export https_proxy='http://localhost:8080'

unset http_proxy
unset https_proxy

DSTDIR=${1}
LINK_LIST=${2}

DATEFULL=$(date +%Y%m%d_%H%M%S)

# cat ${LINK_LIST} | xargs -n1 -I{} wget --adjust-extension --span-hosts --convert-links --backup-converted --page-requisites --directory-prefix=${DSTDIR} {}

N=0
while IFS="" read -r p || [ -n "$p" ]
do
  N=$(expr ${N} + 1)
  printf 'Processing N=%d %s\n' ${N} "${p}"
  SUBDIR="${DSTDIR}/${DATEFULL}/${N}"
  mkdir --parents "${SUBDIR}"
  wget --adjust-extension --span-hosts --convert-links --backup-converted --page-requisites --directory-prefix="${SUBDIR}" "${p}"
done < ${LINK_LIST}
