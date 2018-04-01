#!/bin/bash

netdev=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | sed -nr '1s/^([^ ]+).*/\1/p')
# Disable the network devices
ifconfig $netdev down

# Spoof the mac addresses
/usr/bin/macchanger -r $netdev

# Re-enable the devices
ifconfig $netdev up
exit 0
