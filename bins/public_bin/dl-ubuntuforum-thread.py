#!/usr/bin/env python

# Script originally from TironN on http://ubuntuforums.org/showpost.php?p=9313875&postcount=1879
# requires lynx

import urllib2
import sys
import os
import re

site = sys.argv[1]
page = 1
max_page = 25
site_num = re.findall('(?<=\?t\=)[\d]+', site)[0]
onerun = 0

print "Thread number = %s" % site_num
while page <= max_page:
    
    cmd = 'wget -O thread-%s-%s.html \'http://ubuntuforums.org/printthread.php?t=%s&pp=75&page=%s\'' % (site_num, page, site_num, page)
        
    print "\nNow running: " + cmd
    os.system(cmd)
        
    if onerun == 0:
        file = open('thread-%s-%s.html' % (site_num, page))
        found = re.search('Page\ (\d+)\ of\ (\d+)', file.read())
        page = int(found.group(1))
        max_page = int(found.group(2))
        print max_page
        print page
        onerun = 1
    
        file.close()
    
    cmd = 'lynx -dump thread-%s-%s.html > thread-%s-%s.txt' % (site_num, page, site_num, page)
    print "\nNow running: " + cmd
    os.system(cmd)
        
    page += 1



file_list = []
for i in range(1, (max_page + 1)):
    
    file_list.append('thread-%s-%s.txt ' % (site_num, i))
    
    print file_list

    cmd = 'cat '
for i in file_list:
    cmd = cmd + i + " "

cmd = cmd + '> thread-%s.txt' % site_num

print "Now running: " + cmd
os.system(cmd)

ext = ['html', 'txt']

for p in range(1, (max_page + 1)):
    for e in ext:
        file = 'thread-%s-%d.%s' % (site_num, p, e)
        print file
        os.remove(file)
        
cmd = 'bzip2 thread-%s.txt' % site_num
os.system(cmd)
