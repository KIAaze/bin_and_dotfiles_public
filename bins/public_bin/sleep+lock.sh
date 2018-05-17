#!/bin/bash
set -eu
TIME=${1:-20m}
echo "TIME=${TIME}"
sleep ${TIME} && qdbus org.kde.screensaver /ScreenSaver org.freedesktop.ScreenSaver.Lock
