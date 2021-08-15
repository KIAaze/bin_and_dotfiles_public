#!/bin/bash
# quick info on any processes killed by earlyoom

systemctl --no-pager status earlyoom
echo "==================="
journalctl -u earlyoom.service | grep -e "SIGTERM to process" -e "SIGKILL to process"
echo "==================="
PERCENT_MEM_SIGTERM=$(journalctl -u earlyoom.service | grep "SIGTERM when" | tail -1 | perl -n -e'/SIGTERM\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$1"')
PERCENT_SWAP_SIGTERM=$(journalctl -u earlyoom.service | grep "SIGTERM when" | tail -1 | perl -n -e'/SIGTERM\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$2"')
PERCENT_MEM_SIGKILL=$(journalctl -u earlyoom.service | grep "SIGKILL when" | tail -1 | perl -n -e'/SIGKILL\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$1"')
PERCENT_SWAP_SIGKILL=$(journalctl -u earlyoom.service | grep "SIGKILL when" | tail -1 | perl -n -e'/SIGKILL\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$2"')
echo "PERCENT_MEM_SIGTERM=${PERCENT_MEM_SIGTERM}"
echo "PERCENT_SWAP_SIGTERM=${PERCENT_SWAP_SIGTERM}"
echo "PERCENT_MEM_SIGKILL=${PERCENT_MEM_SIGKILL}"
echo "PERCENT_SWAP_SIGKILL=${PERCENT_SWAP_SIGKILL}"
echo "==================="
echo "For more infos:"
echo "  systemctl status earlyoom"
echo "  journalctl -u earlyoom.service"
