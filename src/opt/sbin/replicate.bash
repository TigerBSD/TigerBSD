#!/usr/bin/env bash

#
# Copyright (c) 2017 Erik Nordstrøm <erik@nordstroem.no>
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

if [ $# -eq 1 ] ; then
  snapname="$( /opt/bin/snapname.sh )"
  fs="$1"
elif [ $# -eq 2 ] ; then
  snapname="$1"
  fs="$2"
else
  echo "Usage: $0 [snapname] filesystem" 1>&2
  exit 1
fi

if [ "${snapname%%@*}" != "$snapname" ] ; then
  echo "Snapname \`$snapname' contains illegal character \`@'." 1>&2
  exit 1
elif [ "${fs%%@*}" != "$fs" ] ; then
  echo "Filesystem name \`$fs' contains illegal character \`@'." 1>&2
  exit 1
elif [ "${HOSTNAME%%@*}" != "$HOSTNAME" ] ; then
  echo "Hostname \`$HOSTNAME' contains illegal character \`@'." 1>&2
  exit 1
fi

case "$fs" in
  bootpool)
    ;&
  zroot)
    dest="zboss/dupli/pool/$HOSTNAME/$fs"
    ;;
  zcarry)
    dest="zboss/dupli/pool/external/$fs"
    ;;
  *)
    echo "Filesystem \`$fs' not in whitelist." 1>&2
    exit 1
    ;;
esac

prev_snap="$( zfs list -H -t snapshot | egrep "^${dest}@" | tail -n1 | cut -f1 )"

if [ $( echo "$prev_snap" | wc -l ) -ne 1 ] ; then
  echo "Failed to get a unique match for most recent" \
       "replication of \`$fs'." 1>&2
  exit 1
fi

prev_snap_fs="${prev_snap%%@*}"
prev_snap_name="${prev_snap##*@}"

if [ "${prev_snap_fs}@$prev_snap_name" != "${prev_snap}" ] ; then
  echo "Encountered illegal character \`@' in previous" \
       "snapshot name \`${prev_snap#*@} of \`${prev_snap}'." 1>&2
  exit 1
fi

zfs snapshot -r "${fs}@$snapname"

zfs send -Ri "@$prev_snap_name" "${fs}@$snapname" | zfs recv -u "$dest"
