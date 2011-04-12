#!/usr/bin/env python

import sys
import os

def usage():
	print 'Usage: '+os.path.basename(sys.argv[0])+' MONTH YEAR'

def main():
    if len(sys.argv)==1:
	    usage()
	    sys.exit()
    
    months=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    CURMON=sys.argv[1]
    CURYEAR=int(sys.argv[2])
    
    idx=months.index(CURMON)
    NEXTMON=months[(idx+1)%12]
    if(idx==11):
      NEXTYEAR=CURYEAR+1
    else:
      NEXTYEAR=CURYEAR
    
    cmd='git log --after="'+CURMON+' 1 '+str(CURYEAR)+'" --before="'+NEXTMON+' 1 '+str(NEXTYEAR)+'"'
    
    print "CURMON=",CURMON
    print "CURYEAR=",CURYEAR
    print "NEXTMON=",NEXTMON
    print "NEXTYEAR=",NEXTYEAR
    print "cmd=",cmd
    
    os.system(cmd)
    
if __name__ == "__main__":
    main()
