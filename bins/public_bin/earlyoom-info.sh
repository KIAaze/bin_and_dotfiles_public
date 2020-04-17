#!/bin/bash
# quick info on any processes killed by earlyoom
journalctl -u earlyoom.service | grep "SIGTERM to process"
