#!/bin/sh

set -ex

iptables-legacy -t nat -A POSTROUTING -s ${INTERNAL_SUBNET} -o eth1 -j SNAT --to-source ${EXTERNAL_ADDR}

# tcpdump -i eth0 -n -w /dump.pcap &
# ulogd -v

sleep infinity
