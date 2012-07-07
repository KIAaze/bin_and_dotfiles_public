#!/usr/bin/env python

from optparse import OptionParser

def function1():
	print 'function1'

def function2():
	print 'function2'

parser = OptionParser()
parser.add_option("-f", "--file", dest="filename",
                  help="write report to FILE", metavar="FOOBAR")
parser.add_option("-q", "--quiet",
                  action="store_false", dest="verbose", default=True,
                  help="don't print status messages to stdout")

parser.add_option("-a", "--a_long",
                  action="store_false", dest="a_name", default=False,
                  help="test")

parser.add_option("-b", "--batch",
                  action="store_true", dest="batch", default=False,
                  help="Process subdirectories (batch job)")

(options, args) = parser.parse_args()
print options.filename
print options.verbose
print options.batch

if options.batch:
	function1()
else:
	function2()
