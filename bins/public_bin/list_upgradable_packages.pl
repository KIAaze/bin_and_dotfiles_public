#!/usr/bin/perl
# # print an upgradable packages list

use warnings;
use strict;

my $print  = 0;
my $before = 'The following packages will be upgraded:';
my $after  = '^\d.+?upgraded';

# open PIPE, 'sudo $(which apt-get) --simulate --verbose-versions upgrade | ';
open PIPE, 'sudo $(which apt-get) --simulate upgrade | ';

while (<PIPE>)
{
	/^$before/ and $print = 1 and next;
	last if /$after/;
	next if $print == 0;
	s/^\s+//g;
	s/\s+/\t/;
	print;
}

close PIPE;

exit ;
