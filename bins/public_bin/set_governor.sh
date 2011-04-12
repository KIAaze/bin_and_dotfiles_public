#! /bin/bash

echo "available governors:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors

echo "The current governor is $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"

echo "Which one do you want?:"
echo "1)userspace"
echo "2)powersave"
echo "3)ondemand"
echo "4)conservative"
echo "5)performance"

read gov

case $gov in
   "1") echo "setting governor to userspace";
	sudo -s; echo userspace > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor; exit;;
   "2") echo "setting governor to powersave";
	sudo -s; echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor; exit;;
   "3") echo "setting governor to ondemand";
	sudo -s; echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor; exit;;
   "4") echo "setting governor to conservative";
	sudo -s; echo conservative > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor; exit;;
   "5") echo "setting governor to performance";
	sudo -s; echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor; exit;;
esac

echo "The current governor is $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
