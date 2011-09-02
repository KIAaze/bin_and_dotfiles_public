#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

def malcxapeligu(read_data):
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
    
    return(read_data)

if __name__ == "__main__":
  dosiero = sys.argv[1]
  with open(dosiero, 'r') as f:
    read_data = f.read()
    read_data = malcxapeligu(read_data)
    print read_data
  f.closed
