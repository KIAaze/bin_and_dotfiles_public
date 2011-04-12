#!/bin/bash

# Assume parameter passed in is an absolute path to a directory.

# For brevity, we won't do argument type or length checking.

echo "Absolute path: `cd $1; pwd`"
