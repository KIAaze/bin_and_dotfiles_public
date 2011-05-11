#!/usr/bin/env python

import random

L=list(open('landlisto.txt'))
random.shuffle(L)
with open('hazarda_landlisto.txt', 'w') as f:
  for i in L:
    f.write(i)
