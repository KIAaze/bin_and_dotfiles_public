#!/usr/bin/env python3

# Usage: cmd FILEDIR PERIOD
# plays a random file from directory FILEDIR approximately once every PERIOD minutes

import os
import random
import sys
import subprocess

FILEDIR = os.path.expanduser(sys.argv[1])
PERIOD = int(sys.argv[2])

if random.randint(0,PERIOD)==0:
  l=os.listdir(FILEDIR)
  soundfile = os.path.join(FILEDIR, l[random.randint(0,len(l)-1)])
  #cmd='mplayer "'+ soundfile +'"'
  #print(cmd)
  #os.system(cmd)
  subprocess.call(['mplayer', soundfile])
  #subprocess.check_output(['mplayer', soundfile])
  #try:
      #retcode = subprocess.call(['mplayer', soundfile])
      #if retcode < 0:
          #print("Child was terminated by signal", -retcode, file=sys.stderr)
      #else:
          #print("Child returned", retcode, file=sys.stderr)
  #except OSError as e:
      #print("Execution failed:", e, file=sys.stderr)
