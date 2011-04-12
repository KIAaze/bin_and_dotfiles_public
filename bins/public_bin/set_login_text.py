#!/usr/bin/env python
# -*- coding: utf-8 -*-
import re
import sys
import tempfile
import shutil
import getopt

$HOME/Lubuntu2/greeter.ui

def get_login_text(FILENAME, REGEX):
  in_file=open(FILENAME,'r')
  pattern = re.compile(REGEX)

  for line in in_file:
    if pattern.match(line):
      m=pattern.match(line)
      login_text=m.group(1)
      in_file.close()
      return login_text

  in_file.close()
  return 'NO MATCH'

def change_login_text(FILENAME, OLD_VERSION, NEW_VERSION):

  in_file=open(FILENAME,'r')
  tmpfilename = tempfile.mktemp()
  out_file = open(tmpfilename, "w")

  for line in in_file:
    out_file.write(re.sub(OLD_VERSION,NEW_VERSION,line))

  out_file.close()
  in_file.close()
  print "Saving original file as "+FILENAME+'.bak'
  shutil.move(FILENAME,FILENAME+'.bak')
  print "Overwriting original file with new file"
  shutil.move(tmpfilename,FILENAME)
  return

def show_login_text():
  old_login_text=get_login_text("tunnellicht.pro",'TUNNELLICHT_VERSION = \\\\\\\\\\\\"(.*)\\\\\\\\\\\\"')
  print old_login_text
  print get_login_text("tunnellicht.nsi",'!define PRODUCT_VERSION "(.*)"')
  return old_login_text

def change_login_text_all(old_login_text,new_login_text):
  print "Changing login_text from "+old_login_text+" to "+new_login_text
  change_login_text("tunnellicht.pro",old_login_text,new_login_text)
  change_login_text("tunnellicht.nsi",old_login_text,new_login_text)

def usage():
    print 'usage:'
    print sys.argv[0]+' -h --help: display help'
    print sys.argv[0]+' -l --login_text: show current login text'
    print sys.argv[0]+' -s --set VERSION: set login_text number'

def main():
    if len(sys.argv)==1:
	    usage()
	    sys.exit()
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hivs:", ["help", "increment", "login_text", "set="])
    except getopt.GetoptError, err:
        # print help information and exit:
        print str(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(2)
        
    for o, a in opts:
        if o in ("-h", "--help"):
            usage()
            sys.exit()
        elif o in ("-l", "--login_text"):
	    print "Current login_text:"
	    old_login_text=show_login_text()
            sys.exit()
        elif o in ("-s", "--set"):
	    new_login_text=a
	    print "Setting login_text to "+new_login_text
	    old_login_text=show_login_text()
	    change_login_text_all(old_login_text,new_login_text)
            sys.exit()
        else:
            assert False, "unhandled option"

if __name__ == "__main__":
    main()

#<property name=label translatable=yes>Next login allowed at: 11:30</property>
