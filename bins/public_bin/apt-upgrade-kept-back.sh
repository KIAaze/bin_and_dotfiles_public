#!/bin/bash
# script to apt upgrade kept back packages
set -eu -o pipefail

sudo apt update

# upgrade packages kept back due to phasing
sudo apt upgrade $(sudo apt-get upgrade | awk '/The following upgrades have been deferred due to phasing:/{flag=1; next} /The following packages have been kept back:/{flag=0} flag' | tr '\n' ' ')

# upgrade other kept back packages
sudo apt upgrade $(sudo apt-get upgrade | awk '/The following packages have been kept back:/{flag=1; next} /0 to upgrade/{flag=0} flag' | tr '\n' ' ')

# NOTE:
# In case of upgrade problems, try:
#   sudo apt full-upgrade
# It can remove conflicting packages.
#
# Otherwise, for drivers, try:
#   sudo ubuntu-drivers install
