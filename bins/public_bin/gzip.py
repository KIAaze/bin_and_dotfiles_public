#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# TODO: remove empty files or add their names to some file?
# TODO: ETA time estimate...
#estimated_time_left = (N-N_done) * (elapsed_time / N_done)
#ETA = now + estimated_time_left
# TODO: logging support... + maybe default logging in a tmp file?
# TODO: make output options easier to understand...
# TODO: Use pigz for speed? (=parallel gzip)
# TODO: parallelize

import os
import re
import sys
import argparse
import tempfile
import subprocess

def writeListToFile(L, outfilename, verbose=False):
  if verbose:
    print('Logging to {}'.format(outfilename))
  with open(outfilename, 'w') as outfile:
    for i in L:
      outfile.write('{}\n'.format(i))

def main():
  
  parser = argparse.ArgumentParser()
  parser.add_argument('file_list', nargs='+', help='files to gzip', metavar='FILE')
  parser.add_argument('--from-file', action='store_true', help='Instead of gzipping passed files, consider them as lists of files to gzip.')
  parser.add_argument('-f', '--force', action='store_true', help='Same as the gzip --force option, i.e. overwrite any existing gzipped files.')
  #parser.add_argument('gzip_args', nargs=argparse.REMAINDER)
  parser.add_argument('-n', '--dry-run', action='store_true', help='Print command that would be run, but do nothing.')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  parser.add_argument('-s', '--min-size', type=int, default=100, help='minimal size in bytes for the file to be considered for gzipping.')
  parser.add_argument('--min-size-gzipped', type=int, default=50, help='minimal size in bytes for gzipped files')
  parser.add_argument('--check', action='store_true', help='Check if gzipped file already exists and if yes, check its size.')
  parser.add_argument('--check-only', action='store_true', help='Check if gzipped file already exists and if yes, check its size. Skip gzipping process.')
  parser.add_argument('--logfile', help='log filenames to logfiles of the form BASE.{zipped,missing,toosmall,toosmall_zipped}.log', metavar='BASE')
  parser.add_argument('--exe', help='Executable to use for compression. Default=gzip. Alternatives: pigz,...', default='gzip')
  args = parser.parse_args()
  
  # hack to prevent mangled filenames on samba shares (seems to happen after lots of processing or stat calls?)
  if args.logfile:
    writeListToFile([], '{}.zipped.log'.format(args.logfile))
    writeListToFile([], '{}.missing.log'.format(args.logfile))
    writeListToFile([], '{}.toosmall.log'.format(args.logfile))
    writeListToFile([], '{}.toosmall_zipped.log'.format(args.logfile))
  
  #print([args.exe] + args.gzip_args)
  #return
  
  print_progress = not args.verbosity > 0 and not args.dry_run
  
  gzip_args = []
  if args.force:
    gzip_args.append('--force')
  
  files_to_gzip = []
  
  if not args.from_file:
    files_to_gzip = args.file_list
  else:
    for file_list_name in args.file_list:
      with open(file_list_name) as file_list:
        for line in file_list:
          files_to_gzip.append(line.strip())
  
  Ntotal = len(files_to_gzip)
  N_missing = 0
  N_toosmall = 0
  N_zipped = 0
  N_toosmall_zipped = 0
  
  files_missing = []
  files_toosmall = []
  files_zipped = []
  files_toosmall_zipped = []
  
  for idx, filepath in enumerate(files_to_gzip):
    
    # skip .gz files
    #if os.path.splitext(filepath)[1] == '.gz':
      #continue
    
    if args.check or args.check_only:
      gzip_file = filepath + '.gz'
      if os.path.isfile(gzip_file):
        if os.path.getsize(gzip_file) < args.min_size_gzipped:
          N_toosmall_zipped += 1
          files_toosmall_zipped.append(gzip_file)
          if args.verbosity > 0:
            print('{} is too small for a gzipped file'.format(gzip_file), file=sys.stderr)
    
    if os.path.isfile(filepath):
      if os.path.getsize(filepath) > args.min_size:
        N_zipped += 1
        files_zipped.append(filepath)
        if not args.check_only:
          cmd = [args.exe] + gzip_args + [filepath]
          if args.dry_run:
            print(' '.join(cmd))
          else:
            if sys.version_info >= (3,5):
              subprocess.run(cmd)
            else:
              subprocess.call(cmd)
      else:
        N_toosmall += 1
        files_toosmall.append(filepath)
        if args.verbosity > 0:
          print('{} is empty or too small for gzipping'.format(filepath), file=sys.stderr)
    else:
      N_missing += 1
      files_missing.append(filepath)
      if args.verbosity > 0:
        print('{} is missing'.format(filepath), file=sys.stderr)
  
    if print_progress:
      print('progress: {}/{}={:.2%}, zipped: {}, missing: {}, empty or too small: {}, too small gzipped files: {}'.format(idx+1, Ntotal, (idx+1)/Ntotal, N_zipped, N_missing, N_toosmall, N_toosmall_zipped), end='\r')
  
  if print_progress:
    print()
  
  if args.logfile:
    writeListToFile(files_zipped, '{}.zipped.log'.format(args.logfile), True)
    writeListToFile(files_missing, '{}.missing.log'.format(args.logfile), True)
    writeListToFile(files_toosmall, '{}.toosmall.log'.format(args.logfile), True)
    writeListToFile(files_toosmall_zipped, '{}.toosmall_zipped.log'.format(args.logfile), True)
  
  return

if __name__ == '__main__':
  main()
