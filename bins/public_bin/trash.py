#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# cf http://www.hardcoded.net/articles/send-files-to-trash-on-all-platforms.htm
# TOFIX: fails when on a different drive, where no trash is accessible (ex: /tmp and usb sticks)
# Requires the send2trash module, which can be installed with:
#   pip install Send2Trash
#   pip3.4 install Send2Trash

import os
import sys
import glob
import argparse
from send2trash import send2trash
#import xdg.BaseDirectory
#import shutil

#dst = xdg.BaseDirectory.xdg_data_home+os.sep+'Trash'
#for src in sys.argv[1:]:
  #print(src+'->'+dst)
  #shutil.move(src, dst)

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('FILE', nargs='+')
  args = parser.parse_args()
  
  for f in args.FILE:
    try:
      #print('Sending {} to trash...'.format(f))
      send2trash(f)
    except Exception as e:
      print(str(e))
    else:
      print('{} successfully sent to trash.'.format(f))
  return 0

if __name__ == '__main__':
  main()
