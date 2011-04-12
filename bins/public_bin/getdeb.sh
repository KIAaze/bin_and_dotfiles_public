#!/bin/bash
sudo apt-get install --reinstall --download-only $1
cp -iv /var/cache/apt/archives/$1* .
