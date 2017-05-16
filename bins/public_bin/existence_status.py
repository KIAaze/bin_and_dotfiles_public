#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import sys
import argparse
import tempfile
import subprocess

def getStatusString(Nexist, Ntotal):
  return 'found: {}/{}={:.2%}, not found {}/{}={:.2%}'.format(Nexist, Ntotal, Nexist/Ntotal, Ntotal-Nexist, Ntotal, (Ntotal-Nexist)/Ntotal)

def main():
  
  parser = argparse.ArgumentParser(description='Reads in a text file listing files or directories and counts how many of them exist. A suffix can be added to the lines in the file before checking for their existence.')
  parser.add_argument('file_list', type=open)
  parser.add_argument('-w', '--workdir', default='.', help='Specify a directory to add in front of each line. If a line starts with /, it will be considered as an absolute path since os.path.join is used.')
  parser.add_argument('-s', '--suffix', default='', help='Add a suffix to each line before checking for existence.')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  parser.add_argument('--logfile', help='log filenames to logfiles of the form BASE.{existing,missing}.log', metavar='BASE', default='empty')
  args = parser.parse_args()
  
  Nlines = sum(1 for line in args.file_list)
  
  args.file_list.seek(0)
  
  Ntotal = 0
  Nexist = 0
  
  #if args.logfile:
    #log_exist_name = args.logfile + '.existing.log'
  #else:
    #tempfile.NamedTemporaryFile(mode='w', delete=False)
  
  log_exist_name = args.logfile + '.existing.log'
  
  with open(log_exist_name, 'w') as log_exist:
    
    for i, line in enumerate(args.file_list):
      ok = False
      Ntotal += 1
      filepath = os.path.join(args.workdir, line.strip()) + args.suffix
      filepath = os.path.normpath(filepath)
      if os.path.exists(filepath):
        Nexist += 1
        ok = True
        log_exist.write('{}\n'.format(filepath))
      if args.verbosity > 0:
        if ok:
          print('{} : OK'.format(filepath))
        else:
          print('{} : NOT FOUND'.format(filepath))
      else:
        print('progress: {}/{}={:.2%}, status: {}'.format(i+1, Nlines, (i+1)/Nlines, getStatusString(Nexist, Ntotal)), end='\r')
      
  if not args.verbosity > 0:
    print()
  else:
    print(getStatusString(Nexist, Ntotal))
  
  return 0

if __name__ == '__main__':
  main()
