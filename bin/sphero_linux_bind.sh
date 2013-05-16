#!/bin/bash
#
# This will create a sphero connection bound to /dev/Sphero-XXX
#
# Requires sudo or ran as root
#
# $1 = unbound /dev/rfcommXX
# $2 = sphero hardware address from hcitool scan
# $3 = sphero three letter color code
#
# Optional parameter
# $4 = bluetooth radio hcix
# 
# Example
#
# sudo ./sphero_linux_bind.sh 1 00:06:66:4A:43:23 PYG hci1
#
#
if [ -z "$4" ]; then
  addr="hci0"
else
  addr=$4
fi
rfcomm -i $addr bind /dev/rfcomm$1 $2 1
ln -s /dev/rfcomm$1 /dev/Sphero-$3
