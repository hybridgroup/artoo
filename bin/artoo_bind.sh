#!/bin/bash
#
# This will create a connection bound to a device located at /dev/<devicename>
#
# Requires sudo or ran as root
#
# $1 = unbound /dev/rfcommXX
# $2 = device hardware address from scan
# $3 = device name
#
# Optional parameter
# $4 = bluetooth radio hcix
# 
# Example
#
# sudo ./artoo_bind.sh 1 00:06:66:4A:43:23 pebble hci1
#
#
if [ -z "$4" ]; then
  addr="hci0"
else
  addr=$4
fi
rfcomm -i $addr bind /dev/rfcomm$1 $2 1
sudo ln -s /dev/rfcomm$1 /dev/$3
