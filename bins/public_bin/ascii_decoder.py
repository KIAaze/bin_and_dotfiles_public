#! /usr/bin/env python

import re
import sys
import os
import shutil
import getopt
import glob

def text2ascii():
	# Convertion from text to ASCII codes
	
	message = raw_input("Enter message to encode: ")
	
	print "Decoded string (in ASCII):"
	for ch in message:
		print ord(ch),
	print "\n\n"

def ascii2text():
	# Convertion from ASCII codes to text
	
	message = raw_input("Enter ASCII codes: ")
	
	decodedMessage = ""
	
	for item in message.split():
		decodedMessage += chr(int(item))
	
	print "Decoded message:", decodedMessage

def usage():
	print 'A script to encode/decode ascii'
	print 'Usage: '+os.path.basename(sys.argv[0])+'[OPTIONS]'
	print '-e, --encrypt: text to ascii'
	print '-d, --decrypt: ascii to text'

def main():
    if len(sys.argv)==1:
	    usage()
	    sys.exit()
    try:
        opts, args = getopt.getopt(sys.argv[1:], "ed", ["encrypt", "decrypt"])
    except getopt.GetoptError, err:
        # print help information and exit:
        print str(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(2)
    for o, a in opts:
        if o in ("-e", "--encrypt"):
            text2ascii()
            sys.exit()
        elif o in ("-d", "--decrypt"):
            ascii2text()
            sys.exit()
        else:
            assert False, "unhandled option"

if __name__ == "__main__":
    main()
