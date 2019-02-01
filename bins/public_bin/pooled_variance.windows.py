#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# loading various modules
from __future__ import division

import os
import re
import sys
import numpy
import argparse
import tempfile
import subprocess

# the main calculation function
def pooled_variance(na, sa, nb, sb):
  fa = (na-1)/((na-1)+(nb-1))
  fb = (nb-1)/((na-1)+(nb-1))
  sa2 = sa**2
  sb2 = sb**2
  sp2 = fa*sa2 + fb*sb2
  sp = numpy.sqrt(sp2)
  return(fa, fb, sp2, sp)

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# https://www.python-course.eu/tkinter_entry_widgets.php

from tkinter import *
# fields = ('na', 'sa', 'nb', 'sb', 'fa=(na-1)/((na-1)+(nb-1))', 'sa^2', 'fa*sa^2', 'fb=(nb-1)/((na-1)+(nb-1))', 'sb^2', 'fb*sb^2', 'sp^2', 'sp')
fields = ('na', 'sa', 'nb', 'sb', '(na-1)/((na-1)+(nb-1))', '(nb-1)/((na-1)+(nb-1))', 'sp^2', 'sp')

def set_defaults(entries):
  entries['na'].delete(0,END)
  entries['na'].insert(0, '{}'.format(10) )
  entries['sa'].delete(0,END)
  entries['sa'].insert(0, '{}'.format(0.282) )
  entries['nb'].delete(0,END)
  entries['nb'].insert(0, '{}'.format(7) )
  entries['sb'].delete(0,END)
  entries['sb'].insert(0, '{}'.format(0.196) )
  return
  
def pooled_variance_wrapper(entries):
  na =  int(entries['na'].get())
  sa =  float(entries['sa'].get())
  nb =  int(entries['nb'].get())
  sb =  float(entries['sb'].get())
  fa, fb, sp2, sp = pooled_variance(na, sa, nb, sb)
  print('na={}, sa={}, nb={}, sb={} -> fa={}, fb={}, sp2={}, sp={}'.format(na, sa, nb, sb, fa, fb, sp2, sp))
  entries['(na-1)/((na-1)+(nb-1))'].delete(0, END)
  entries['(na-1)/((na-1)+(nb-1))'].insert(0, '{}'.format(fa) )
  entries['(nb-1)/((na-1)+(nb-1))'].delete(0, END)
  entries['(nb-1)/((na-1)+(nb-1))'].insert(0, '{}'.format(fb) )
  entries['sp^2'].delete(0, END)
  entries['sp^2'].insert(0, '{}'.format(sp2) )
  entries['sp'].delete(0, END)
  entries['sp'].insert(0, '{}'.format(sp) )
  return

def makeform(root, fields):
  entries = {}
  for field in fields:
    row = Frame(root)
    lab = Label(row, width=22, text=field+": ", anchor='w')
    ent = Entry(row)
    ent.insert(0,"0")
    row.pack(side=TOP, fill=X, padx=5, pady=5)
    lab.pack(side=LEFT)
    ent.pack(side=RIGHT, expand=YES, fill=X)
    entries[field] = ent
  return entries

if __name__ == '__main__':
  root = Tk()
  ents = makeform(root, fields)
  root.bind('<Return>', (lambda event, e=ents: fetch(e)))
  
  set_defaults(ents)
  
  b1 = Button(root, text='Calculate', command=(lambda e=ents: pooled_variance_wrapper(e)))
  b1.pack(side=LEFT, padx=5, pady=5)
  b2 = Button(root, text='Quit', command=root.quit)
  b2.pack(side=LEFT, padx=5, pady=5)
  root.mainloop()
