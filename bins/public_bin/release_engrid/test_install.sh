#!/bin/bash
#simple script to test install
automake && ./configure --prefix=$(pwd)/debian/webcontentcontrol/usr/ && make clean all && make install
