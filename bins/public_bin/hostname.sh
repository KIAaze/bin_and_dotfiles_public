#!/bin/bash
echo "-a, --alias            alias names"
hostname --alias
echo "-A, --all-fqdns        all long host names (FQDNs)"
hostname --all-fqdns
echo "-b, --boot             set default hostname if none available"
hostname --boot
echo "-d, --domain           DNS domain name"
hostname --domain
echo "-f, --fqdn, --long     long host name (FQDN)"
hostname --fqdn
echo "-i, --ip-address       addresses for the host name"
hostname --ip-address
echo "-I, --all-ip-addresses all addresses for the host"
hostname --all-ip-addresses
echo "-s, --short            short host name"
hostname --short
echo "-y, --yp, --nis        NIS/YP domain name"
hostname --nis
