#!/usr/bin/env python
# Conversion from text to ASCII codes

message = raw_input("Enter message to encode: ")

print "Decoded string (in ASCII):"
for ch in message:
   print "%03d"%ord(ch),
