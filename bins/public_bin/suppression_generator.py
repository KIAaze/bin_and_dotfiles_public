#! /usr/bin/env python
# A script to automatically generate a suppression file for errors you don't care about. :)

# Created in almost less than 5 minutes! Python, the more you use it, the more you love it. :) (Unlike ROOT :P )

import re
import sys
import os

def usage():
	print "A script to automatically generate a suppression file for errors you don't care about. :)"
	print "How to use it:"
	print '1) '+sys.argv[0]+' ./yourprogram'
	print "This will generate a leaks.txt file and a leaks.supp file."
	print "2) valgrind --suppressions=leaks.supp ./yourprogram"
	print "...and all error messages should be gone. :)"

	#print "1) yes | valgrind --gen-suppressions=yes ./yourprogram  1>leaks.txt 2>&1"
	#print "2) ./suppression_generator.py"
	#print "3) valgrind --suppressions=leaks.supp ./yourprogram"

def gen_suppfile():
	in_file=open("leaks.txt",'r')
	out_file=open("leaks.supp",'w')
	for line in in_file:
		if re.findall(r'{\n',line):
			print '{\n'
			out_file.write('{\n')
		if not (re.findall(r'^==',line)):
			print line
			out_file.write(line)
		if re.findall(r'}\n',line):
			print '\n'
			out_file.write('\n')
	in_file.close()
	out_file.close()

def create_leakfile(programname):
	#cmd='yes | valgrind --gen-suppressions=yes '+programname+' 1>leaks.txt 2>&1'
	cmd='yes | valgrind --gen-suppressions=yes '+programname+' 1>/dev/null 2>leaks.txt'
	print "Running: "+cmd
	if( os.system(cmd) != 0 ):
		sys.exit()

if len(sys.argv)==1:
	usage()
	sys.exit()

programname=sys.argv[1]
print "Creating leak file..."
create_leakfile(programname)
print "Generating suppression file..."
gen_suppfile()
print "Now run:"
print "valgrind --suppressions=leaks.supp "+programname
