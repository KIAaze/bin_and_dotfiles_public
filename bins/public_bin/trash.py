#!/usr/bin/env python
import sys
#import os
#import xdg.BaseDirectory
#import shutil

#dst = xdg.BaseDirectory.xdg_data_home+os.sep+'Trash'
#for src in sys.argv[1:]:
  #print(src+'->'+dst)
  #shutil.move(src, dst)

# cf http://www.hardcoded.net/articles/send-files-to-trash-on-all-platforms.htm

from send2trash import send2trash
for src in sys.argv[1:]:
  print('sending '+src+' to trash')
  send2trash(src)
