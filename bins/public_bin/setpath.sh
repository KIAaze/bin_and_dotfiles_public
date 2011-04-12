#!/bin/bash
echo "Old library path: $LD_LIBRARY_PATH"
echo 'export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH'
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
echo "New library path: $LD_LIBRARY_PATH"
