#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# removes empty directories and broken links (but allows removing only empty dirs)
# fslint does the job already... ;)

import os
import argparse
import sys

def removeEmptyDirs(arguments):
  '''Remove empty directories.'''
  for dir_to_process in arguments.directories:
    print('=== Processing',dir_to_process,'===')
    for root, dirs, files in os.walk(dir_to_process, topdown=False):
      for name in dirs:
        current_dir = os.path.join(root, name)
        if not os.listdir(current_dir):
          print('Removing empty directory',current_dir)
          if not arguments.no_act:
            os.rmdir(current_dir)
  return

def get_argument_parser():
  # command-line option handling
  parser = argparse.ArgumentParser(description = 'Remove empty directories.', fromfile_prefix_chars='@')
  parser.add_argument('-n', '--no-act', action='store_true', default=False, help='Do not actually remove empty directories. Just simulate.')
  parser.add_argument('directories', action="store", nargs='+', help='directories to process')
  return parser

def main(args=None):
  parser = get_argument_parser()
  arguments = parser.parse_args() if args is None else parser.parse_args(args) # This is just to enable calling the main function with arguments from another script for example.
  
  if not len(sys.argv) > 1:
    parser.print_help()
  else:
    removeEmptyDirs(arguments)
  
  return(0)

if __name__ == "__main__":
  sys.exit(main())
