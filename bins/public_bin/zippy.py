#!/usr/bin/env python3

import argparse
import random

parser = argparse.ArgumentParser()
parser.add_argument("yowfile", nargs='?')
parser.add_argument("-N", default=1, type=int)
args = parser.parse_args()

if not args.yowfile:
  args.yowfile='/usr/share/xemacs21/xemacs-packages/etc/yow.lines'

with open(args.yowfile) as f:
  lines = f.read().strip().strip('\x00').split('\x00')
  lines = lines[1:]
  selection = random.sample(lines, args.N)
  for i in selection:
    print(i.strip())
