#!/bin/bash

# use pacmd to see available cards+profiles
# use arandr to save/load display profiles
# cf https://unix.stackexchange.com/questions/62818/how-can-i-switch-between-different-audio-output-hardware-using-the-shell

function set_HDMI_on()
{
  pacmd set-card-profile 0 output:hdmi-stereo
  xrandr --output LVDS-1 --primary --mode 1366x768 --pos 1920x312 --rotate normal --output DP-1 --off --output HDMI-1 --mode 1920x1080i --pos 0x0 --rotate normal --output VGA-1 --off

  # conf
  #   xrandr --output LVDS-1 --primary --mode 1366x768 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --mode 1024x768 --pos 1366x0 --rotate normal --output VGA-1 --off
}

function set_HDMI_off()
{
  pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo
  xrandr --output LVDS-1 --primary --mode 1366x768 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output VGA-1 --off
}

STATE=${1:-0}

if [[ ${1} -eq 1 ]]
then
  set_HDMI_on
else
  set_HDMI_off
fi
