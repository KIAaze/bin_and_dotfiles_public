#!/bin/bash
# https://unix.stackexchange.com/questions/99334/how-to-fill-90-of-the-free-memory

MemAvailable=$(awk '/MemAvailable/{printf "%d\n", $2 * 1.00;}' < /proc/meminfo)
SwapFree=$(awk '/SwapFree/{printf "%d\n", $2 * 1.00;}' < /proc/meminfo)
SwapTotal=$(awk '/SwapTotal/{printf "%d\n", $2 * 1.00;}' < /proc/meminfo)
MemTotal=$(awk '/MemTotal/{printf "%d\n", $2 * 1.00;}' < /proc/meminfo)

PERCENT_MEM_SIGTERM=$(systemctl status earlyoom | perl -n -e'/SIGTERM\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$1"')
PERCENT_SWAP_SIGTERM=$(systemctl status earlyoom | perl -n -e'/SIGTERM\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$2"')
PERCENT_MEM_SIGKILL=$(systemctl status earlyoom | perl -n -e'/SIGKILL\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$1"')
PERCENT_SWAP_SIGKILL=$(systemctl status earlyoom | perl -n -e'/SIGKILL\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$2"')
echo "PERCENT_MEM_SIGTERM=${PERCENT_MEM_SIGTERM}"
echo "PERCENT_SWAP_SIGTERM=${PERCENT_SWAP_SIGTERM}"
echo "PERCENT_MEM_SIGKILL=${PERCENT_MEM_SIGKILL}"
echo "PERCENT_SWAP_SIGKILL=${PERCENT_SWAP_SIGKILL}"

Total = SwapTotal+MemTotal
MemAvailable+SwapFree

stress-ng --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 1.00;}' < /proc/meminfo)k --vm-keep -m 1

stress-ng --vm-bytes 25065529k --vm-keep -m 1
