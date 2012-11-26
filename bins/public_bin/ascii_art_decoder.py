#!/usr/bin/env python3

import sys

f=open(sys.argv[1])
str=f.read()
str=str.replace('0','.')
N=int(sys.argv[2])
for i in range(len(str)//N):
  print(str[N*i:N*(i+1)])
