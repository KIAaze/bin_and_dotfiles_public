#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
import re
import sys
import getopt

CALCULATION_STRING = sys.argv[1]
if len(sys.argv)>2:
  FORMAT_STRING = sys.argv[2]

#TODO: Use "%Y/%m/%d %H:%M" eventually.

pattern=re.compile('(d?)(\d+):(\d+):(\d+) ([\+-]) (d?)(\d+):(\d+):(\d+)')
m=pattern.match(CALCULATION_STRING)
m.groups()
d1 = m.group(1)
H1 = int(m.group(2))
M1 = int(m.group(3))
S1 = int(m.group(4))
op = m.group(5)
d2 = m.group(6)
H2 = int(m.group(7))
M2 = int(m.group(8))
S2 = int(m.group(9))

#print d1
#print H1
#print M1
#print op
#print d2
#print H2
#print M2

today=datetime.datetime.today()

if d1=='d':
  t1 = datetime.timedelta(0,H1*60*60+M1*60+S1)
else:
  t1 = datetime.datetime(today.year,today.month,today.day,H1,M1,S1)

if d2=='d':
  t2 = datetime.timedelta(0,H2*60*60+M2*60+S2)
else:
  t2 = datetime.datetime(today.year,today.month,today.day,H2,M2,S2)

if op=='+':
  result=t1+t2
else:
  result=t1-t2

#if we have a timedelta object
if d1=='' and d2=='':
  result = datetime.datetime(1901,1,1)+result

#print result
#print str(result.hour)+':'+str(result.minute)
if len(sys.argv)==3:
  print result.strftime(FORMAT_STRING)
else:
  print result.strftime('%H:%M:%S')

#now=datetime.datetime.now()

#H=int(now.strftime("%H"))
#M=int(now.strftime("%M"))
#S=int(now.strftime("%S"))

#diff = datetime.datetime.today() - datetime.datetime(2010, 6, 6, 23, 6)
#print diff.days,"days ", diff.seconds/60/60,"hours ", diff.seconds/60 - (diff.seconds/60/60 * 60),"minutes "

#end=now+HMS
#rem=end-now

#def main():
    #if len(sys.argv)==1:
	    #usage()
	    #sys.exit()
    #try:
        #opts, args = getopt.getopt(sys.argv[1:], "hivs:", ["help", "increment", "version", "set="])
    #except getopt.GetoptError, err:
        ## print help information and exit:
        #print str(err) # will print something like "option -a not recognized"
        #usage()
        #sys.exit(2)
        
    #for o, a in opts:
        #if o in ("-h", "--help"):
            #usage()
            #sys.exit()
        #elif o in ("-i", "--increment"):
	    #print "Incrementing version"
	    #old_version=show_version()
	    #new_version=nextversion(old_version)
	    #change_version_all(old_version,new_version)
            #sys.exit()
        #elif o in ("-v", "--version"):
	    #print "Current version:"
	    #old_version=show_version()
            #sys.exit()
        #elif o in ("-s", "--set"):
	    #new_version=a
	    #print "Setting version to "+new_version
	    #old_version=show_version()
	    #change_version_all(old_version,new_version)
            #sys.exit()
        #else:
            #assert False, "unhandled option"

#if __name__ == "__main__":
    #main()
