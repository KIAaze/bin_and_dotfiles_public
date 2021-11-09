#!/bin/bash
# based on https://serverfault.com/questions/426394/how-to-check-if-an-rsa-public-private-key-pair-match

# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
        echo "checks if a private key and public key match"
        echo
        echo "usage :"
        echo "`basename $0` PRIVKEY PUBKEY ..."
        exit 0
fi

PRIVKEY="${1}"
PUBKEY="${2}"
#diff -q  <(ssh-keygen -y -f "${PRIVKEY}" | cut -d' ' -f 2) <(cut -d' ' -f 2 "${PUBKEY}")
diff -q -s <(ssh-keygen -l -f "${PRIVKEY}" | cut -d' ' -f2) <(ssh-keygen -l -f "${PUBKEY}" | cut -d' ' -f2)
