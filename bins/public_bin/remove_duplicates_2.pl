#!/usr/bin/perl -w

# Author: Gautam Gopalakrishnan.
# Feel free to reuse.
#
# Usage: dupe.pl filename.csv [file2.csv] [file3.csv] ...
# Ofcourse, this script does not care if the input file is a csv.
# Unique lines are placed in the order they appear
# WARNING: Original file is overwritten.

use strict;
my (@final, %hash, $file) = ((), (), "");

if (not defined $ARGV[0]) {
	print "Usage: dupe.pl filename.csv [file2.csv] [file3.csv] ...\n";
	exit -1;
}
foreach $file (@ARGV) {
	if (!open FILE, "+<$file") {
		print "Unable to open input csv file for read-write, '$file' $!\n";
		next;
	}
	while (<FILE>) {
		if (not exists $hash{$_}) {
			push @final, $_;
			$hash{$_} = 1;
		}
	}
	truncate FILE, 0;
	seek FILE, 0, 0;
	print FILE @final;
	close FILE;
	%hash = @final = ();
}
