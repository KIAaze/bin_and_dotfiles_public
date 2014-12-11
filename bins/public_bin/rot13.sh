#!/bin/bash
# Decode rot13 encoded text files.
tr 'a-zA-Z' 'n-za-mN-ZA-M'<$1
