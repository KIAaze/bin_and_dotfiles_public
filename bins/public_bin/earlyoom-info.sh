#!/bin/bash
# quick info on any processes killed by earlyoom

systemctl --no-pager status earlyoom

JOURNAL_OUTPUT=$(mktemp)
journalctl -u earlyoom.service >${JOURNAL_OUTPUT}
echo "==================="
cat ${JOURNAL_OUTPUT} | grep -e "SIGTERM to process" -e "SIGKILL to process"
echo "==================="
PERCENT_MEM_SIGTERM=$(cat ${JOURNAL_OUTPUT} | grep "SIGTERM when" | tail -1 | perl -n -e'/SIGTERM\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$1"')
PERCENT_SWAP_SIGTERM=$(cat ${JOURNAL_OUTPUT} | grep "SIGTERM when" | tail -1 | perl -n -e'/SIGTERM\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$2"')
PERCENT_MEM_SIGKILL=$(cat ${JOURNAL_OUTPUT} | grep "SIGKILL when" | tail -1 | perl -n -e'/SIGKILL\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$1"')
PERCENT_SWAP_SIGKILL=$(cat ${JOURNAL_OUTPUT} | grep "SIGKILL when" | tail -1 | perl -n -e'/SIGKILL\s+when\s+mem\s+<=\s+([-.0-9]*)%\s+and\s+swap\s+<=\s+([-.0-9]*)%/ && print "$2"')
echo "PERCENT_MEM_SIGTERM=${PERCENT_MEM_SIGTERM}"
echo "PERCENT_SWAP_SIGTERM=${PERCENT_SWAP_SIGTERM}"
echo "PERCENT_MEM_SIGKILL=${PERCENT_MEM_SIGKILL}"
echo "PERCENT_SWAP_SIGKILL=${PERCENT_SWAP_SIGKILL}"
echo "==================="
echo "For more infos:"
echo "  systemctl status earlyoom"
echo "  journalctl -u earlyoom.service"
