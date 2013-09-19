#!/usr/bin/env python3

import os
from os.path import join, getsize
import sys
import argparse

# TODO: get size of broken symlinks, etc... Use "du" through sys call? (turning this into simple wrapper)
def disk_usage(arguments):
  for toscan in arguments.folders:
    size = getsize(toscan)
    if os.path.isdir(toscan):
      for root, dirs, files in os.walk(toscan):
        if root=='.':
          for x in arguments.exclude:
            if x in dirs:
              if arguments.verbose>0:
                print('excluding',join(root,x))
              dirs.remove(x)
        size += sum(getsize(join(root, name)) for name in files)
        size += sum(getsize(join(root, name)) for name in dirs)
        #print(root, "consumes", end=" ")
        #print(, end=" ")
        #print("bytes in", len(files), "non-directory files")
        #if 'CVS' in dirs:
            #dirs.remove('CVS')  # don't visit CVS directories
    print(str(size)+' bytes\t'+toscan)
    
def get_argument_parser():
  # command-line option handling
  parser = argparse.ArgumentParser(description = 'Analyze disk usage (similar to the du command.)', fromfile_prefix_chars='@')

  parser.add_argument('-v','--verbose', action="count", default=0, help='verbosity level')
  parser.add_argument('folders', action="store", nargs='+', help='folders to analyze')
  #parser.add_argument('-x','--exclude', nargs='+', default=[], help='patterns the files should not match')
  parser.add_argument('-x','--exclude', action='append', default=[], help='patterns the files should not match')

  return parser

def main(args=None):
  parser = get_argument_parser()
  arguments = parser.parse_args() if args is None else parser.parse_args(args) # This is just to enable calling the main function with arguments from another script for example.

  if arguments.verbose:
    print('---------')
    print(arguments)
    print('---------')
  
  if not len(sys.argv) > 1:
    parser.print_help()
  else:
    return(disk_usage(arguments))
  
  return(0)

if __name__ == "__main__":
  sys.exit(main())
