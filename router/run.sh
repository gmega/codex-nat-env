#!/bin/sh

set -ex

iptables-legacy -t nat -A POSTROUTING -s $SUBNET_INTERNAL -o eth1 -j SNAT --to-source $ADDR_EXTERNAL

#tcpdump -i eth0 -n -w /dump.pcap &

#ulogd -v
sleep 100000
