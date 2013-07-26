#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import argparse
import hashlib
import subprocess
import fnmatch
import tempfile
import shutil

# Problems:
# -different files in same folder
# -a/f1 and a/b/f1

# convert to unix format
def fromdos(filename):
  try:
    retcode = subprocess.call(["fromdos", filename])
    if retcode < 0:
      print("Child was terminated by signal", -retcode, file=sys.stderr)
    #else:
      #print("Child returned", retcode, file=sys.stderr)
  except OSError as e:
    print("Execution failed:", e, file=sys.stderr)

# get the sha1sum corresponding to the UNIX version of the file (i.e. like after running fromdos/dos2unix)
def getSha1sumOfUnixVersion(filename):
  with open(filename, 'rb') as f:
    sha1sum = hashlib.sha1(f.read().replace(b'\r\n',b'\n')).hexdigest()      
    return(sha1sum)

# move contents of srcdir into dstdir
def moveContents(srcdir,dstdir):
  contents = os.listdir(srcdir)
  for i in contents:
    src_item = os.path.join(srcdir,i)
    dst_item = os.path.join(dstdir,i)
    #print((src_item, dstdir))
    try:
      if os.path.isfile(dstdir):
        print('ERROR:',dstdir,'is a file!!! Aborting to avoid overwriting files while moving contents.', file=sys.stderr)
        sys.exit(-1)
      shutil.move(src_item, dstdir)
    except OSError as e:
      print("Execution failed:", e, file=sys.stderr)

# automagically organize data folders...
def organize(arguments):
  
  fileAndSha1sum_list = []
  
  # TODO: It might be possible to combine the two os.walks into one...
  
  if arguments.verbose:
    print('=== ANALYSIS ===')
  # first we analyze the directory structure for any potential problems
  for root, dirnames, filenames in os.walk(arguments.srcdir, topdown=False):
    local_sha1sum_set = set()
    for filename in fnmatch.filter(filenames, arguments.pattern):
      if not arguments.exclude_pattern or not ( filename in fnmatch.filter(filenames, arguments.exclude_pattern) ):
      
        # build the pathname
        fullpath = os.path.join(root, filename)
        
        # get their sha1sums
        sha1sum = getSha1sumOfUnixVersion(fullpath)
        
        if arguments.verbose:
          print((sha1sum, fullpath))
        
        fileAndSha1sum_list.append( (sha1sum, fullpath) )
        local_sha1sum_set.add(sha1sum)
    
    if(len(local_sha1sum_set)>1):
      print('ERROR:',root,'contains more than one matching file with the same sha1sum.')
      sys.exit(-1)
  
  if arguments.verbose:
    print('=== PROCESSING ===')
  # starting from the deepest directory move all directories containing files matching the specified pattern into the corresponding sha1sum folder with the same relative path
  for root, dirnames, filenames in os.walk(arguments.srcdir, topdown=False):
    for filename in fnmatch.filter(filenames, arguments.pattern):
      if not arguments.exclude_pattern or not ( filename in fnmatch.filter(filenames, arguments.exclude_pattern) ):
      
        # build the pathname
        fullpath = os.path.join(root, filename)
        
        # get their sha1sums
        sha1sum = getSha1sumOfUnixVersion(fullpath)
        
        if arguments.verbose:
          print((sha1sum, fullpath))
        
        fileAndSha1sum_list.append( (sha1sum, fullpath) )
        
        src = os.path.dirname(fullpath)
        dst = os.path.join(arguments.dstdir, sha1sum, os.path.relpath(src, start=arguments.srcdir))
        
        if os.path.samefile(src,arguments.srcdir):
          print('WARNING:',fullpath,'is in the root of the source directory',arguments.srcdir,'which cannot be moved. Skipping.', file=sys.stderr)
          continue

        if arguments.verbose:
          print('Moving',src,'to',dst)
        
        # if the destination exists and is not empty
        if os.path.exists(dst) and os.listdir(dst):
          print('WARNING:',dst,'exists and is not empty! Just moving contents.', file=sys.stderr)
          if not arguments.no_act:
            moveContents(src,dst)
        else:
          if not arguments.no_act:
            if not os.path.isdir(src):
              print('ERROR:',src,'is not a directory!!! Aborting to avoid overwriting files while renaming.', file=sys.stderr)
              sys.exit(-1)
            os.renames(src,dst)

  ## get all unique sha1sums
  #sha1sum_set = {sha1sum for (sha1sum, fullpath) in fileAndSha1sum_list}
  
  ## create folder for each sha1sum
  #for sha1sum in sha1sum_set:
    #if arguments.verbose:
      #print(sha1sum)
    #os.makedirs(os.path.join(arguments.dstdir,sha1sum), exist_ok=True)

  #for root, dirs, files in os.walk(sys.argv[1]):
    #for name in files:
      #print(os.path.join(root, name))
    #for name in dirs:
      #print(os.path.join(root, name))
  
  #os.makedirs(sys.argv[1], exist_ok=True)

  #os.renames(sys.argv[1],os.path.join(sys.argv[2],sys.argv[1]))


def get_argument_parser():
  # command-line option handling
  parser = argparse.ArgumentParser(description = 'Sort folders containing specific files into folders named after the sha1sums of those files.', fromfile_prefix_chars='@')

  parser.add_argument("-v", "--verbose", action="store_true", default=False, help="Be verbose")
  parser.add_argument('-s','--srcdir', help='source directory to scan for .EXT files', required=True)
  parser.add_argument('-d','--dstdir', help='destination directory into which to sort folders', required=True)
  parser.add_argument('-p','--pattern', help='patterns the files should match', required=True)
  parser.add_argument('--exclude-pattern', help='patterns the files should not match')
  parser.add_argument("-n", "--no-act", action="store_true", default=False, help="Do not actually rename/move files. Just simulate.")

  return parser

def main(args=None):
  parser = get_argument_parser()
  arguments = parser.parse_args() if args is None else parser.parse_args(args) # This is just to enable calling the main function with arguments from another script for example.
  
  if not len(sys.argv) > 1:
    parser.print_help()
  else:
    if arguments.verbose:
      print('---------')
      print(arguments)
      print('---------')

    organize(arguments)
  return(0)

if __name__ == "__main__":
  #moveContents(sys.argv[1], sys.argv[2])
  sys.exit(main())
