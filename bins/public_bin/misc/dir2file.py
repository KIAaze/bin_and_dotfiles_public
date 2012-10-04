#! /usr/bin/env python

import re
import sys
import os
import shutil
import glob

files=glob.glob('*/*.jpg')
#print files
for name in files:
	newname=name.replace('/','_')
	print newname
	shutil.copyfile(name,'all/'+newname)

