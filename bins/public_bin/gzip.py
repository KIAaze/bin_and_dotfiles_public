#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# TODO: remove empty files or add their names to some file?
# TODO: ETA time estimate...
#estimated_time_left = (N-N_done) * (elapsed_time / N_done)
#ETA = now + estimated_time_left

import os
import re
import sys
import argparse
import tempfile
import subprocess

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('file_list', nargs='+', help='files to gzip', metavar='FILE')
  parser.add_argument('--from-file', action='store_true', help='Instead of gzipping passed files, consider them as lists of files to gzip.')
  parser.add_argument('-f', '--force', action='store_true', help='Same as the gzip --force option, i.e. overwrite any existing gzipped files.')
  #parser.add_argument('gzip_args', nargs=argparse.REMAINDER)
  parser.add_argument('-n', '--dry-run', action='store_true', help='Print command that would be run, but do nothing.')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  args = parser.parse_args()
  
  #print(args)
  #print(['gzip'] + args.gzip_args)
  #return
  
  print_progress = not args.verbosity > 0 and not args.dry_run
  
  gzip_args = []
  if args.force:
    gzip_args.append('-f')
  
  files_to_gzip = []
  
  if not args.from_file:
    files_to_gzip = args.file_list
  else:
    for file_list_name in args.file_list:
      with open(file_list_name) as file_list:
        for line in file_list:
          files_to_gzip.append(line.strip())
  
  Ntotal = len(files_to_gzip)
  N_not_found = 0
  N_empty = 0
  N_zipped = 0
  
  for idx, filepath in enumerate(files_to_gzip):
    if print_progress:
      print('progress: {}/{}={:.2%}, zipped: {}, not found: {}, empty: {}'.format(idx+1, Ntotal, (idx+1)/Ntotal, N_zipped, N_not_found, N_empty), end='\r')
    if os.path.isfile(filepath):
      if os.path.getsize(filepath) > 0:
        N_zipped += 1
        cmd = ['gzip'] + gzip_args + [filepath]
        if args.dry_run:
          print(' '.join(cmd))
        else:
          subprocess.run(cmd)
      else:
        N_empty += 1
        if args.verbosity > 0:
          print('{} is empty'.format(filepath), file=sys.stderr)
    else:
      N_not_found += 1
      if args.verbosity > 0:
        print('{} not found'.format(filepath), file=sys.stderr)
  
  if print_progress:
    print()
  
  return 0

if __name__ == '__main__':
  main()
