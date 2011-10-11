#!/usr/bin/env python

# counts the number of words in a text file. Also works for the same word multiple times on one line.
# usage: script FILE WORD
# cf: http://bytes.com/topic/python/answers/797207-regular-expressions-get-number-matches

import sys
import re
txt=open(sys.argv[1]).read()
len(txt)
rexp = re.compile(sys.argv[2])
match=rexp.findall(txt)
print len(match)
