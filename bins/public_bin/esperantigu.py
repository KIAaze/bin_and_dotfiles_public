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
  print read_data
f.closed
