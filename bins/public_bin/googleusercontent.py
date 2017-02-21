#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# cf: http://stackoverflow.com/questions/7133676/generate-alphanumeric-strings-sequentially

from itertools import product
from string import digits, ascii_uppercase, ascii_lowercase

def main():
  chars = digits + ascii_lowercase
  for comb in product(chars, repeat=4):
    print('doc-{}{}-{}{}-docs.googleusercontent.com'.format(*comb))

if __name__ == '__main__':
  main()
