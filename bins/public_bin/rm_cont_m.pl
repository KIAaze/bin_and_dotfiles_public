#!/usr/bin/perl
# Remove Control M's ^M
# Matt Wright           (mattw@worldwidemart.com)
# Version 1.0           (http://worldwidemart.com/scripts/)
# Created on: 10/95	Last Modified on: 12/7/95

while (<>) {
   $_ =~ s/\cM\n/\n/g;
   print $_;
}


# To use this script, type:
# rm_cont_m.pl infile > outfile

# This script will remove those pesky control M's off of the end of your
# scripts after you have edited them in DOS or Windows.

# The infile should be the name of the file you want to remove control 
# m's from and the outfile should be a different file where you want to 
# redirect the output to.  Don't use the infile as the outfile or it will
# remove your original file.  :-(

# If you do not specify an outfile, then the script will print the contents
# to the screen.

# Ths script has no error checking, and is very simple.
