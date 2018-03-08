#!/bin/bash
# Retrieve the extension id for an addon from its install.rdf
# cf http://kb.mozillazine.org/Determine_extension_ID

set -eu

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo "usage :"
        echo "`basename $0` arg1"
        exit 0
fi

unzip -qc $1 install.rdf | xmlstarlet sel \
  -N rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns# \
  -N em=http://www.mozilla.org/2004/em-rdf# \
  -t -v \
  "//rdf:Description[@about='urn:mozilla:install-manifest']/em:id"
