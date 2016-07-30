#!/usr/bin/env python3

import sys

with open(sys.argv[1],'w')as f:
  for i in range(0x10ffff+1):
    f.write('i={} : '.format(i))
    try:
      f.write(chr(i))
      print('i={}: OK'.format(i))
    except:
      print('i={}: FAIL'.format(i))
    f.write('\n')
