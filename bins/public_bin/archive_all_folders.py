#! /usr/bin/env python

import re
import sys
import os
import shutil
import glob

folders=glob.glob('*/')
#print files
for f in folders:
	archive=f.replace('/','.tar.gz')
	cmd="tar -czvf "+archive+" "+f
	print cmd
	os.system(cmd)

