#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Usage example::

  #!/usr/bin/env python
  from __future__ import print_function, division

  from progress_bar import progress_bar_set, progress_bar_end

  for i in range(200):
    progress_bar_set(i/199)
  progress_bar_end()

'''

from __future__ import print_function, division

import sys
import time
import subprocess
import argparse

# NOTES:
# interesting alternative for printing: sys.stdout.write(str(i)+'\r')
# ncurses could also be a nice option.
# TODO: We could use the actual elapsed time to dynamically adjust the sleep time. But this is mainly for reference and use in scripts where a progress bar is needed.

def progress_bar_set(fraction):
  str_open = '{:7.2%} ['.format(fraction)
  str_close = ']'
  ncols = int(subprocess.check_output(['tput','cols']))
  BARLENGTH = ncols - len(str_open) - len(str_close)
  N_before = int( (BARLENGTH - 1)*fraction )
  N_after = BARLENGTH - N_before - 1
  str_to_print = str_open + N_before*'=' + '>' + N_after*' ' + str_close
  
  # Printing "\r" is the actual trick.
  if sys.version_info.major == 2:
    subprocess.call(["printf", str_to_print.replace('%','%%') + '\r']) # works for python2, but not very elegant (but faster! Why?)
  else:
    print(str_to_print, end='\r') # works for python3

  return

def progress_bar_end():
  print()
  return

def example():
  N = 100
  for i in range(N):
    progress_bar_set(i/(N-1))
  progress_bar_end()

def timed_progress_bar(seconds, Nsteps):
  
  SLEEPTIME = seconds/(Nsteps+1)

  for i in range(Nsteps+1):
    progress_bar_set(i/(Nsteps))
    time.sleep(SLEEPTIME)
    
  progress_bar_end()
  return

def progress_bar_argparse():
  parser = argparse.ArgumentParser(description="Displays a progress bar in the terminal going from 0 to 100% over *seconds* seconds in *Nsteps* steps.")
  parser.add_argument("seconds", help="number of seconds the progress bar should run", type=float, default=1, nargs='?')
  parser.add_argument("Nsteps", help="number of steps to use in the progress bar", type=int, default=100, nargs='?')
  args = parser.parse_args()
  timed_progress_bar(args.seconds, args.Nsteps)

if __name__ == '__main__':
  progress_bar_argparse()
  #example()
