#!/bin/bash
# TODO: Use piuparts? (slower, but safer): http://piuparts.debian.org/doc/README.html#_how_to_use_piuparts_in_5_minutes
set -eux
sudo apt-get remove --purge dansguardian tinyproxy firehol
sudo apt-get remove --purge webcontentcontrol
sudo apt-get install webcontentcontrol
/usr/bin/webcontentcontrol
sudo apt-get remove webcontentcontrol
sudo apt-get remove --purge webcontentcontrol
sudo apt-get remove --purge dansguardian tinyproxy firehol
