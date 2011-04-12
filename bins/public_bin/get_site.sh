#!/bin/bash

wget -np -r -nc -p -E -l inf -w 1 --random-wait -k $1
