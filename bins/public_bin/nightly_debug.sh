#!/bin/bash
cd ~/temp
rm -rf engrid
git clone $GIT_HTTP_URL
cd engrid/src
./scripts/rebuild.sh
echo SUCCESS
