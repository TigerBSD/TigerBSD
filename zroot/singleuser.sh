#!/bin/sh

#
# Run this script after booting into single user mode.
#
# These commands were taken from section 23.6 Rebuilding World
# of the FreeBSD Handbook [1], but are useful in general
# when in single user mode.
#
# [1]: https://www.freebsd.org/doc/handbook/makeworld.html#idp77127408
#

mount -u /
mount -a -t ufs
swapon -a
zfs set readonly=off zroot
zfs mount -a
kbdcontrol -l us.dvorak
adjkerntz -i
