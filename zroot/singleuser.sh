#!/bin/sh

mount -u /
mount -a -t ufs
swapon -a
zfs set readonly=off zroot
zfs mount -a
kbdcontrol -l us.dvorak
adjkerntz -i
