#! /usr/bin/env python
#lists files on one single line (useful for makefiles)

import glob
import sys

def usage():
	print 'lists files on one single line (useful for makefiles)'
	print 'Usage: '+sys.argv[0]+' <extension>'

if len(sys.argv)==1:
	usage()
	sys.exit()

#print sys.argv[1]

files=glob.glob('*'+sys.argv[1])
#print files
for f in files:
	print f,
