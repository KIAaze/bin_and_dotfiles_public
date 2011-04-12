#!/bin/bash

astyle --style=gnu *.C *.cxx *.cpp *.h *.c && hg commit
