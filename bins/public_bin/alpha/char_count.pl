#!/usr/bin/perl
#Count the number of characters in each line and report the quantity for each line.
#The name of the file must be specified by user laucning the program
$srcfile = "std-input";
# Initialize the counters
$CharCount = 0;
$LineCount = 0;

do while() $linecount >0 { $srcfile = $_; # Save the line's contents
$LineCount = $LineCount + 1;
$LineLen = length($TheLine); # capture how many characters (minus the line # break) are on this line
$CharCount = $CharCount + $LineLen;
print "Line . $linecount : . $charcount . characters read \n";
# intitialize a line buffer
@lines = ();
# read lines of input
while(defined($line = <>)){ chomp $line; # this means that newlines will not be counted
$nlines++; # counts the lines
@words = split /\s+/, $line;
$nwords += @words; # counts the words
@chars = split //,$line; $nchars += @chars; # counts the characters
# reverse the characters in the line
# and push this onto a stack
@chars = reverse @chars; $string = join "",
@chars; push @lines, $string; }
print "lines: $nlines, words: $nwords, characters $nchars\n";
print "reversed:\n"; # by popping lines off the stack they come out in the
# reverse order:
while($line = pop @lines){ print "$line\n"; }
