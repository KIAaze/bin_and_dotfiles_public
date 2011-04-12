#! /usr/bin/env python

import sys
import os

def usage():
  print 'usage : '+sys.argv[0]+' DIRECTORY1 DIRECTORY2'

# md5deep options:
# -r : recursive
# -o f : only process regular files
def md5deep_and_strip(dir,file_abs,file_stripped):
  print 'dir =', dir
  
  print '=== Calculating MD5 for ' + dir + ' ==='
  cmd='md5deep -r -o f ' + dir + '/* > ' + file_abs
  print cmd
  if( os.system(cmd) != 0 ):
    sys.exit(1)
  
  print '=== Removing prefix : '+file_abs+'->'+file_stripped+' ==='
  in_file = open(file_abs,'r')
  out_file = open(file_stripped,'w')
  for line in in_file:
    #print line
    stripped_line = line.replace(dir+'/','')
    #print stripped_line
    out_file.write(stripped_line)
  in_file.close()
  out_file.close()
  
if len(sys.argv)!=3:
  usage()
  sys.exit(0)

DIRECTORY_1=os.path.abspath(sys.argv[1])
DIRECTORY_2=os.path.abspath(sys.argv[2])

md5deep_and_strip(DIRECTORY_1,'md5_1.txt','md5_1_clean.txt')
md5deep_and_strip(DIRECTORY_2,'md5_2.txt','md5_2_clean.txt')

print '=== DIFFERENCES ==='
cmd='diff md5_1_clean.txt md5_2_clean.txt'
print cmd
if( os.system(cmd) != 0 ):
  sys.exit(1)
