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

#
# NOTE: If replication fails with message "cannot receive incremental
# stream: destination [...] has been modified", rollback the receiving
# end to last received snapshot.
#

if [ $# -eq 1 ] ; then
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

replication_dest_of_to_from ()
{
  if [ $# -eq 2 ] ; then
    local replicate_to="$1"
    local replicate_from="$2"
  else
    echo "Function \`replication_dest_of_to_from' recieved bad number of arguments." 1>&2
    exit 1
  fi

  case "$replicate_from" in
    bootpool)
      ;&
    zroot)
      dest="$replicate_to/dupli/$HOSTNAME/$replicate_from"
      ;;
    zboss/kek/local-origin)
      ;&
    zboss/kek/purchased)
      dest="$replicate_to/dupli/external/$replicate_from"
      ;;
    *)
      echo "Filesystem \`$replicate_from' not in whitelist." 1>&2
      exit 1
      ;;
  esac

  echo "$dest"
}

replicate_to_from ()
{
  if [ $# -eq 2 ] ; then
    local replicate_to="$1"
    local replicate_from="$2"
  else
    echo "Function \`destroy_prev_snaps' recieved bad number of arguments." 1>&2
    exit 1
  fi

  if [ "${replicate_from%%@*}" != "$replicate_from" ] ; then
    echo "Filesystem name \`$fs' contains illegal character \`@'." 1>&2
    exit 1
  fi

  dest="$( replication_dest_of_to_from "$replicate_to" "$replicate_from" )"
  prev_snap="$( zfs list -Ht snapshot | cut -f1 | egrep "^${dest}@" | tail -n1 || true )"
  if [ -z "$prev_snap" ] ; then
    n_match_prev=0
  else
    n_match_prev="$( echo "$prev_snap" | wc -l )"
  fi

  if [ "$n_match_prev" -eq 0 ] ; then
    zfs send -vR "${replicate_from}@$snapname" | zfs recv -u "$dest"
  elif [ "$n_match_prev" -eq 1 ] ; then
    prev_snap_fs="${prev_snap%%@*}"
    prev_snap_name="${prev_snap##*@}"

    if [ "${prev_snap_fs}@$prev_snap_name" != "${prev_snap}" ] ; then
      echo "Encountered illegal character \`@' in previous" \
           "snapshot name \`${prev_snap#*@}' of \`${prev_snap}'." 1>&2
      exit 1
    fi

    zfs send -vRi "@$prev_snap_name" "${replicate_from}@$snapname" | zfs recv -u "$dest"
  else
    echo "Failed to get a unique match for most recent" \
         "replication of \`$fs'." 1>&2
    exit 1
  fi
}

zpool_is_online ()
{
  pool="$1"

  pool_health="$( zpool list -H -o health "$pool" )"

  if [ $? -eq 0 ] && [ "$pool_health" = "ONLINE" ] ; then
    return 0
  fi

  echo $pool was NOT observed as being online 1>&2

  return 1
}

for pool in zboss zcarry ; do
  if zpool_is_online "$pool" ; then
    replicate_to_from "$pool" bootpool
    replicate_to_from "$pool" zroot
  fi
done

if zpool_is_online zcarry && zpool_is_online zboss ; then
  replicate_to_from zcarry zboss/kek/local-origin
  replicate_to_from zcarry zboss/kek/purchased
fi
