#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
from subprocess import Popen
from subprocess import PIPE
import re
from math import log, ceil
 
def is_power_of_2(n):
    return log(n, 2) % 1.0 == 0.0
 
def next_power_of_2(n):
    return int( (2 ** ceil(log(n, 2))) )

def resize_to_POT(image):
  bla = Popen(["identify", image], stdout=PIPE).communicate()[0]
  #print bla
  m = re.match(r".*?(\d+)x(\d+).*", bla)
  #print m.groups()
  width=int(m.group(1))
  height=int(m.group(2))
  #print width
  #print height
  if not is_power_of_2(width) or not is_power_of_2(height):
    new_width=next_power_of_2(width)
    new_height=next_power_of_2(height)
    #print new_width
    #print new_height
    cmd='mogrify -resize ' + str(new_width) + 'x' + str(new_height) + '\! ' + image
    print cmd
    os.system(cmd)
  else:
    print image+' is POT: '+str(width)+'x'+ str(height)

resize_to_POT(sys.argv[1])

