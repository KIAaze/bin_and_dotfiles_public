#!/bin/bash
# Simple script to check whether X11 or Wayland is used:
loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}'
