#!/bin/bash
set -eux

MSG="ERROR"

trap "echo success" EXIT
trap "echo failure" INT TERM

ls /fuu

ls /

MSG="SUCCESS"
