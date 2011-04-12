#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re

pattern = re.compile("webcontentcontrol \((.*)\) \w+; urgency=low")
#webcontentcontrol (1.3.3-0ubuntu3) lucid; urgency=low

f = open('./debian/changelog','r')
line = f.readline()
f.close()

#print line

if pattern.match(line):
  m = pattern.match(line)
  #print 'match'
  print m.group(1)
