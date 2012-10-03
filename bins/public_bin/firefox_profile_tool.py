#!/usr/bin/env python3
# script to symlink a file into the chrome folder of every firefox profile (and maybe eventually do a bit more related to firefox profiles in the future)

import argparse
import configparser
import sys
import os
  
def symlinkIntoChrome(file_to_link, profile_file = '~/.mozilla/firefox/profiles.ini'):
  
  profile_file = os.path.expanduser(profile_file)
  file_to_link = os.path.expanduser(file_to_link)
  
  #print('LOLOL')
  config = configparser.ConfigParser()
  #print(profile_file)
  if config.read(profile_file):
    #print(config.sections())
    for sectionID in config.sections():
      if 'Path' in config[sectionID]:
        dstdir = os.path.join(os.path.dirname(profile_file), config[sectionID]['Path'], 'chrome')
        if not os.path.isdir(dstdir):
          os.makedirs(dstdir)
        dst = os.path.join(dstdir, os.path.basename(file_to_link))
        print(dst + ' -> ' + file_to_link)
        if not os.path.exists(dst):
          os.symlink(file_to_link, dst)
        else:
          print('ERROR: '+dst+' exists.', file=sys.stderr)
 
      #for key in config[sectionID]:
        #print(key)
  else:
    print('ERROR: Failed to read profile file.', file=sys.stderr)

def main():
  parser = argparse.ArgumentParser(description = 'symlink a file into the chrome folder of every firefox profile')
  parser.add_argument('infile', action="store", help='file to symlink')
  arguments = parser.parse_args()
  #print(arguments)
  symlinkIntoChrome(file_to_link=arguments.infile)
  
if __name__ == "__main__":
  main()
