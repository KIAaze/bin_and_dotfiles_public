#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

with open(sys.argv[1], 'r') as f:
  read_data = f.read()
  
  read_data = read_data.replace('cx','ĉ')
  read_data = read_data.replace('gx','ĝ')
  read_data = read_data.replace('hx','ĥ')
  read_data = read_data.replace('jx','ĵ')
  read_data = read_data.replace('sx','ŝ')
  read_data = read_data.replace('ux','ŭ')

  read_data = read_data.replace('Cx','Ĉ')
  read_data = read_data.replace('Gx','Ĝ')
  read_data = read_data.replace('Hx','Ĥ')
  read_data = read_data.replace('Jx','Ĵ')
  read_data = read_data.replace('Sx','Ŝ')
  read_data = read_data.replace('Ux','Ŭ')

  read_data = read_data.replace('cX','ĉ')
  read_data = read_data.replace('gX','ĝ')
  read_data = read_data.replace('hX','ĥ')
  read_data = read_data.replace('jX','ĵ')
  read_data = read_data.replace('sX','ŝ')
  read_data = read_data.replace('uX','ŭ')

  read_data = read_data.replace('CX','Ĉ')
  read_data = read_data.replace('GX','Ĝ')
  read_data = read_data.replace('HX','Ĥ')
  read_data = read_data.replace('JX','Ĵ')
  read_data = read_data.replace('SX','Ŝ')
  read_data = read_data.replace('UX','Ŭ')

  print read_data
f.closed
