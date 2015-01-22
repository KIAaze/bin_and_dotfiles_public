#!/bin/bash

# print out server fingerprints
# cf http://www.phcomp.co.uk/Tutorials/Unix-And-Linux/ssh-check-server-fingerprint.html

for f in /etc/ssh/*.pub
do
  ssh-keygen -l -f $f
done
