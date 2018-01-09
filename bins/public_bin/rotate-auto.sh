#!/bin/bash
ffmpeg -i ${1} -c:a copy ${1%.mp4}.auto.mp4
