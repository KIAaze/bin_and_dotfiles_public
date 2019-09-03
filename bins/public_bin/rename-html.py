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
import textwrap

color_dictionary = {
  'default' : '\033[m',
  'black' : '\033[0;38;5;0m',
  'red' : '\033[0;38;5;1m',
  'green' : '\033[0;38;5;2m',
  'brown' : '\033[0;38;5;3m',
  'blue' : '\033[0;38;5;4m',
  'magenta' : '\033[0;38;5;5m',
  'cyan' : '\033[0;38;5;6m',
  'white' : '\033[0;38;5;7m',
}

def convert_to_FAT32_filename(s):
  s = s.replace('|','-')
  # s = s.replace('&','and')
  s = s.replace(':','-')
  s = s.replace('>','@')
  s = s.replace('<','@')
  s = s.replace('?','@')
  # s = s.replace('`','@')
  s = s.replace('\\','-')
  # s = s.replace('/','-')
  # s = s.replace('£','GBP')
  return s

def rename_html(args):
  if args.verbosity >= 3:
    print(args)
  
  (infile_head, infile_tail) = os.path.split(args.infile)
  (infile_root, infile_ext) = os.path.splitext(infile_tail)
  
  if args.outfile:
    outfile = args.outfile
  else:
    outfile_root = convert_to_FAT32_filename(infile_root)
    outfile = os.path.join(infile_head, outfile_root+'.html')
  
  (outfile_head, outfile_tail) = os.path.split(outfile)
  (outfile_root, outfile_ext) = os.path.splitext(outfile_tail)
  
  infile_dir = os.path.join(infile_head, infile_root+'_files')
  outfile_dir = os.path.join(outfile_head, outfile_root+'_files')
  
  if args.verbosity >= 2:
    print('Input:\n  {}\n  {}'.format(args.infile, infile_dir))
    print('Output:\n  {}\n  {}'.format(outfile, outfile_dir))
  
  safechars = '()&;|'
  
  # oldtxt = urllib.parse.quote(infile_root+'_files', encoding='latin-1')
  # newtxt = urllib.parse.quote(outfile_root+'_files', encoding='latin-1')
  
  # oldtxt = urllib.parse.quote(html.escape(infile_root+'_files'))
  # newtxt = urllib.parse.quote(html.escape(outfile_root+'_files'))
  
  oldtxt = urllib.parse.quote(html.escape(infile_root+'_files'), safe = safechars)
  newtxt = urllib.parse.quote(html.escape(outfile_root+'_files'), safe = safechars)
  
  if args.verbosity >= 2:
    print('Text replacment:\n  {}\n  {}'.format(oldtxt, newtxt))
  
  enc = 'latin-1'
  with open(args.infile, 'r', encoding=enc) as f:
    intxt = f.read()
  
  N = intxt.count(oldtxt)
  outtxt = intxt.replace(oldtxt, newtxt)
  
  with open(args.infile, 'w', encoding=enc) as f:
    f.write(outtxt)
  
  os.rename(infile_dir, outfile_dir)
  os.rename(args.infile, outfile)
  
  if args.verbosity >= 2:
    print('N={} occurences replaced.'.format(N))
  
  return

def main():
  parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=textwrap.dedent('''
  Renames wesbites saved via Mozilla Firefox, so they can be saved to a FAT32 partition.
  It also fixes websites saved with non-html extensions and which therefore fail to open in Firefox.
  
  Example uses for recursive renaming:
    find . -name "*.com" -type f -exec rename-html.py {} \;
    find . -name "*.html" -type f -exec rename-html.py --pretty {} \;
  '''))
  parser.add_argument('infile')
  parser.add_argument('outfile', nargs='?')
  parser.add_argument('--pretty', action='store_true', help='Print output of the form "[OK/FAIL] infile"')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  args = parser.parse_args()
  
  try:
    rename_html(args)
  except:
    if args.pretty:
      status = color_dictionary['red']+'[FAIL]'+color_dictionary['default']
    else:
      raise
  else:
    if args.pretty:
      status = color_dictionary['green']+'[ OK ]'+color_dictionary['default']
  
  if args.pretty:
    print('{} {}'.format(status, args.infile))
  
  return 0

if __name__ == '__main__':
  main()
