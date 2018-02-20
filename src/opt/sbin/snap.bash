#!/usr/bin/env bash

#
# Copyright (c) 2016, 2017, 2018 Erik Nordstrøm <erik@nordstroem.no>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

set -euo pipefail

if [ $# -eq 0 ] ; then
  snapname="$( /opt/bin/snapname.sh )"
elif [ $# -eq 1 ] ; then
  snapname="$1"
else
  echo "Usage: $0 [snapname]" 1>&2
  exit 1
fi

if [ "${snapname%%@*}" != "$snapname" ] ; then
  echo "Snapname \`$snapname' contains illegal character \`@'." 1>&2
  exit 1
elif [ "${HOSTNAME%%@*}" != "$HOSTNAME" ] ; then
  echo "Hostname \`$HOSTNAME' contains illegal character \`@'." 1>&2
  exit 1
fi

destroy_prev_snaps ()
{
  sync

  if [ $# -eq 1 ] ; then
    flags=""
    fs="$1"
  elif [ $# -eq 2 ] ; then
    flags="$1"
    fs="$2"
  else
    echo "Function \`destroy_prev_snaps' recieved bad number of arguments." 1>&2
    exit 1
  fi

  if [ "${fs%%@*}" != "$fs" ] ; then
    echo "Filesystem name \`$fs' contains illegal character \`@'." 1>&2
    exit 1
  fi

  if [ -z "$flags" ] ; then
    zfs list -Ht snapshot | cut -f1 | egrep "^${fs}@" | sed '$d' | xargs -L1 zfs destroy
  else
    zfs list -Ht snapshot | cut -f1 | egrep "^${fs}@" | sed '$d' | xargs -L1 zfs destroy "$flags"
  fi
}

zfs snapshot -r "zboss/lol@$snapname"
#destroy_prev_snaps -r zboss/lol
zfs snapshot -r "zboss/kek@$snapname"
#destroy_prev_snaps -r zboss/kek

zfs snapshot -r "$snapname" zroot
#destroy_prev_snaps -r zroot
#destroy_prev_snaps -r "$( dest zroot )"

zfs snapshot "$snapname" bootpool
#destroy_prev_snaps bootpool
#destroy_prev_snaps "$( dest bootpool )"
