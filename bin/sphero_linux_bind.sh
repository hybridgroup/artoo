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
# Example
#
# sudo ./sphero_linux_bind.sh 1 00:06:66:4A:43:23 PYG
#
#
rfcomm bind /dev/rfcomm$1 $2 1
ln -s /dev/rfcomm$1 /dev/Sphero-$3
