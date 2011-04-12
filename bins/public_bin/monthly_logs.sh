#!/bin/bash
# git log --after="MMM DD YYYY" ex. ("Jun 20 2008")
#   show commits that occur after a certain date (non strict ordering)
# 
# git log --before="MMM DD YYYY" ex. ("Jun 20 2008")
#   show commits that occur before a certain date (strict ordering)

git log --after="Jan 19 2009" --before="Mar 1 2009" >~/February.log
git log --after="Mar 1 2009" >~/March.log
