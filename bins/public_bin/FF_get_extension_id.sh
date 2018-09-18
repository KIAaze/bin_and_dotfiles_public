#!/bin/bash
# Retrieve the extension id for a firefox addon from its install.rdf or manifest.json and optionally install it as a global extension.
# cf http://kb.mozillazine.org/Determine_extension_ID

set -eu

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo "usage :"
        echo "`basename $0` XPI_FILE"
        exit 0
fi

# old addons:
if unzip -qc ${1} install.rdf &>/dev/null
then
  echo "==> Old non-WebAPI addon:"
  NAME=$(unzip -qc ${1} install.rdf | xmlstarlet sel \
  -N rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns# \
  -N em=http://www.mozilla.org/2004/em-rdf# \
  -t -v \
  "//rdf:Description[@about='urn:mozilla:install-manifest']/em:name")
  ID=$(unzip -qc ${1} install.rdf | xmlstarlet sel \
  -N rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns# \
  -N em=http://www.mozilla.org/2004/em-rdf# \
  -t -v \
  "//rdf:Description[@about='urn:mozilla:install-manifest']/em:id")
else
  echo "==> New WebAPI addon:"
  # new WebAPI addons:
  NAME=$(unzip -qc ${1} manifest.json | jq '.name')
  ID=$(unzip -qc ${1} manifest.json | jq '.applications.gecko.id')
  
  # remove double quotes: https://stackoverflow.com/questions/9733338/shell-script-remove-first-and-last-quote-from-a-variable
  temp="${NAME%\"}"
  NAME="${temp#\"}"
  temp="${ID%\"}"
  ID="${temp#\"}"

fi
echo "NAME: ${NAME}"
echo "ID: ${ID}"

INSTALLDIR=/usr/lib/firefox-addons/extensions
#INSTALLDIR=${HOME}/.mozilla/extensions/ # Does not seem to work. :(

echo "Install to ${INSTALLDIR} ?"
read ans
case $ans in
  y|Y|yes) sudo cp --interactive --verbose ${1} ${INSTALLDIR}/${ID}.xpi;;
esac
