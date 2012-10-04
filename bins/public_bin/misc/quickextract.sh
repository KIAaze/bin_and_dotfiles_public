#!/bin/bash
set -eux
ssh $HOST_SF "cd $PWD && $*"
