#!/usr/bin/env sh

snapname="$( date +%Y-%m-%d )-$( freebsd-version )-$( date +%s )"

zfs snapshot -r bootpool@$snapname
zfs snapshot -r zroot@$snapname

zfs destroy -r zroot/tmp@$snapname
zfs destroy -r zroot/usr/ports@$snapname
zfs destroy -r zroot/usr/src@$snapname
zfs destroy -r zroot/var/audit@$snapname
zfs destroy -r zroot/var/crash@$snapname
zfs destroy -r zroot/var/log@$snapname
zfs destroy -r zroot/var/tmp@$snapname

zfs snapshot -r zcarry@$snapname

zfs snapshot -r zboss@$snapname
