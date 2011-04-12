#! /usr/bin/env python

import string

in_file=open("/etc/passwd",'r')
for line in in_file:
	A=string.split(line,':')
	username=A[0]
	uid=int(A[2])
	if ( uid >= 1000 and uid != 65534 ) or uid == 0 :
	    print username
in_file.close()
