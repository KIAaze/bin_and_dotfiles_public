#!/usr/bin/env python
import sys
import re

def usage():
    print "converts \'CamelCase\' to \'Camel Case\'"
    print 'usage: '+sys.argv[0]+' STRING'

def space_out_camel_case(stringAsCamelCase):
    """Adds spaces to a camel case string.  Failure to space out string returns the original string.
    >>> space_out_camel_case('DMLSServicesOtherBSTextLLC')
    'DMLS Services Other BS Text LLC'
    """
    
    if stringAsCamelCase is None:
        return None

    pattern = re.compile('([A-Z][A-Z][a-z])|([a-z][A-Z])')
    #print pattern
    return pattern.sub(lambda m: m.group()[:1] + " " + m.group()[1:], stringAsCamelCase)

def lowercase_first_letter(stringAsCamelCase):
  index=0
  ret=''
  for ch in stringAsCamelCase:
    if index==0:
      #print ch.lower()
      ret += ch.lower()
    else:
      #print ch
      ret += ch
    index = index + 1
  #print ret
  return ret

def uppercase_first_letter(stringAsCamelCase):
  index=0
  ret=''
  for ch in stringAsCamelCase:
    if index==0:
      #print ch.upper()
      ret += ch.upper()
    else:
      #print ch
      ret += ch
    index = index + 1
  #print ret
  return ret

if len(sys.argv)==1:
	usage()
	sys.exit()

oldname=sys.argv[1]
newname=space_out_camel_case(oldname)
#print oldname +' -> '+ newname
#wordlist = newname.split(' ')
#print wordlist
#print wordlist[0].lower()

#print space_out_camel_case(oldname)
print lowercase_first_letter(oldname)
#print uppercase_first_letter(oldname)
