#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

with open(sys.argv[1], 'r') as f:
  read_data = f.read()

  read_data = read_data.replace('ĉ', 'cx')
  read_data = read_data.replace('ĝ', 'gx')
  read_data = read_data.replace('ĥ', 'hx')
  read_data = read_data.replace('ĵ', 'jx')
  read_data = read_data.replace('ŝ', 'sx')
  read_data = read_data.replace('ŭ', 'ux')

  read_data = read_data.replace('Ĉ', 'Cx')
  read_data = read_data.replace('Ĝ', 'Gx')
  read_data = read_data.replace('Ĥ', 'Hx')
  read_data = read_data.replace('Ĵ', 'Jx')
  read_data = read_data.replace('Ŝ', 'Sx')
  read_data = read_data.replace('Ŭ', 'Ux')

  print read_data
f.closed
