#!/bin/bash

# print out server fingerprints
# cf http://www.phcomp.co.uk/Tutorials/Unix-And-Linux/ssh-check-server-fingerprint.html

# single-line version:
# for f in /etc/ssh/*.pub; do ssh-keygen -l -f $f; done

DIR=${1:-/etc/ssh}
echo "DIR: ${DIR}"

for f in "${DIR}"/*.pub
do
  echo "--> file: ${f}"
#   ssh-keygen -l -f $f -E md5
  ssh-keygen -l -f ${f}
done

for f in "${DIR}"/*.pub
do
  echo "--> file: ${f}"
  #ssh-keygen -l -f $f -E sha256
  awk '{print $2}' ${f} | base64 -d | sha256sum -b | awk '{print $1}' | xxd -r -p | base64 # (sha256 on old OpenSSH)
done
