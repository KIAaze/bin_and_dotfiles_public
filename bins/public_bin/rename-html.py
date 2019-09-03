#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import division

import os
import re
import sys
import argparse
import tempfile
import subprocess
import urllib.parse
import html
import cgi

def 

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('infile')
  parser.add_argument('outfile')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  args = parser.parse_args()
  print(args)
  
  (infile_head, infile_tail) = os.path.split(args.infile)
  (infile_root, infile_ext) = os.path.splitext(infile_tail)
  
  (outfile_head, outfile_tail) = os.path.split(args.outfile)
  (outfile_root, outfile_ext) = os.path.splitext(outfile_tail)
  
  infile_dir = os.path.join(infile_head, infile_root+'_files')
  outfile_dir = os.path.join(outfile_head, outfile_root+'_files')
  
  print('Input:\n  {}\n  {}'.format(args.infile, infile_dir))
  print('Output:\n  {}\n  {}'.format(args.outfile, outfile_dir))
  
  safechars = '()&;|'
  
  # oldtxt = infile_root+'_files'
  # newtxt = oldtxt
  # newtxt = newtxt.replace(' ', '%20')
  # newtxt = newtxt.replace('&', '&amp;')
  # oldtxt = urllib.parse.quote(infile_root+'_files', encoding='latin-1')
  # newtxt = urllib.parse.quote(outfile_root+'_files', encoding='latin-1')

  # oldtxt = urllib.parse.quote(html.escape(infile_root+'_files'))
  # newtxt = urllib.parse.quote(html.escape(outfile_root+'_files'))
  
  oldtxt = urllib.parse.quote(html.escape(infile_root+'_files'), safe = safechars)
  newtxt = urllib.parse.quote(html.escape(outfile_root+'_files'), safe = safechars)
  
  print('Text replacment:\n  {}\n  {}'.format(oldtxt, newtxt))
  
  enc = 'latin-1'
  with open(args.infile, 'r', encoding=enc) as f:
    intxt = f.read()
  
  # p = re.compile(oldtxt)
  # (outtxt, N) = p.subn(newtxt, intxt)
  N = intxt.count(oldtxt)
  outtxt = intxt.replace(oldtxt, newtxt)
  
  with open(args.outfile, 'w', encoding=enc) as f:
    f.write(outtxt)
    print('LOLOL')
    os.rename(infile_dir, outfile_dir)
    os.remove(args.infile)
  
  print('N={} occurences replaced.'.format(N))
  
  # print(txt)
    # f.write('-f\nbar')
  
  return 0

if __name__ == '__main__':
  main()
