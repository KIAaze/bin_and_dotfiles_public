#!/usr/bin/env perl

# Script originally from unutbu on http://ubuntuforums.org/showpost.php?p=4782850&postcount=880
# requires lynx

# Usage:
# dl-ubuntuforum-thread.pl "http://ubuntuforums.org/showthread.php?t=442945" 
use strict;
use warnings;

my $thread=shift @ARGV;
warn "thread=$thread\n";
my $page=1;
my $current_page;
my $max_page=2;
my $cmd;
my ($thread_num)=($thread=~m/\?t=(\d+)/);
warn "thread_num=$thread_num\n";
while (1) {
    last if ($page>$max_page);
    $cmd="wget -O thread${thread_num}-${page}.html \"http://ubuntuforums.org/printthread.php?t=$thread_num&pp=75&page=${page}\"";

    print "$cmd\n";
    system($cmd);
    open(FILE,"<","thread${thread_num}-${page}.html") || die; 
    while (<FILE>) {
	if (/Page (\d+) of (\d+)/) {
	    ($current_page,$max_page)=($1,$2);
	    print "Page $current_page of $max_page\n";
	    last;
	}
    }
    close(FILE);
    $cmd="lynx -dump thread${thread_num}-${page}.html > thread${thread_num}-${page}.txt";
    print "$cmd\n";
    system($cmd);
    $page++;
}

$cmd="cat " . join(' ', map {"thread${thread_num}-${_}.txt"} (1..$max_page)) . "> thread${thread_num}.txt";
print "$cmd\n";
system($cmd);

for $page (1..$max_page) {
    for my $ext (qw(txt html)) {
	my $file="thread${thread_num}-${page}.${ext}";
	$cmd="unlink($file)";
	print "$cmd\n";
	unlink($file);
    }    
}

$cmd="bzip2 thread${thread_num}.txt";
system($cmd);
