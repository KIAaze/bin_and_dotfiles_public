#! /usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
import argparse
import textwrap

def md5deep_and_strip(directory, file_abs, file_stripped):
  print( 'directory =', directory)
  
  print( '=== Calculating MD5 for ' + directory + ' ===')
  cmd='md5deep -r -o f ' + directory + '/* > ' + file_abs
  print(cmd)
  if( os.system(cmd) != 0 ):
    sys.exit(1)

  hashdata = []
  print('=== Removing prefix : '+file_abs+'->'+file_stripped+' ===')
  in_file = open(file_abs,'r')
  out_file = open(file_stripped,'w')
  for line in in_file:
    stripped_line = line.replace(directory+'/','')
    out_file.write(stripped_line)
    fullpath = line.split()[1]
    hashdata.append(stripped_line.split() + [fullpath])
  in_file.close()
  out_file.close()

  return hashdata

def main():
  parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
    description=textwrap.dedent('''\
      Runs md5deep on two directories and compares the results.

      Note: For simple duplicate file search, just use fdupes, fslint (or findup from the same package) or fslint-gui instead.

      md5deep options:
        -r : recursive
        -o f : only process regular files

      Direct md5deep usage: md5deep -r -o f DIRECTORY

      TODO: Get rid of tempfiles, unless otherwise specified.
      TODO: Just use meld for comparison?
      TODO: GUI? fslint-gui mod?
      TODO: Could be improved to only compare files with the same basepath, etc...
      '''))

  parser.add_argument('DIR1')
  parser.add_argument('DIR2')
  parser.add_argument('-v', '--verbose', action="count", dest="verbosity", default=0, help='verbosity level')
  args = parser.parse_args()
  print(args)

  DIRECTORY_1 = os.path.abspath(args.DIR1)
  DIRECTORY_2 = os.path.abspath(args.DIR2)

  hashdata1 = md5deep_and_strip(DIRECTORY_1,'md5_1.txt','md5_1_clean.txt')
  hashdata2 = md5deep_and_strip(DIRECTORY_2,'md5_2.txt','md5_2_clean.txt')

  print('=== DIFFERENCES ===')
  cmd='diff md5_1_clean.txt md5_2_clean.txt'
  print(cmd)
  if( os.system(cmd) != 0 ):
    differences_found = True
  else:
    differences_found = False
    

  hash_dict = dict()
  hash_dict_fullpath = dict()
  
  for h, f, fullpath in hashdata1:
    if h not in hash_dict.keys():
      hash_dict[h]=set([(f, fullpath)])
    else:
      hash_dict[h].add((f, fullpath))
      
  for h, f, fullpath in hashdata2:
    if h not in hash_dict.keys():
      hash_dict[h]=set([(f, fullpath)])
    else:
      hash_dict[h].add((f, fullpath))

  for k,v in hash_dict.items():
    if len(v) > 1:
      print('Duplicates found for {}:'.format(k))
      for i, j in v:
        print('  {} {}'.format(i, j))
  
  if differences_found:
    sys.exit(1)
  
  return 0

if __name__ == '__main__':
  main()
