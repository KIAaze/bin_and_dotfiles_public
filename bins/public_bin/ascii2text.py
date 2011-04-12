#!/usr/bin/env python
# Convertion from ASCII codes to text

message = raw_input("Enter ASCII codes: ")

decodedMessage = ""

for item in message.split():
   decodedMessage += chr(int(item))   

print "Decoded message:", decodedMessage

