#!/usr/bin/env bash

#
# Copyright (c) 2016, 2017 Erik Nordstrøm <erik@nordstroem.no>
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

dest ()
{
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

  echo "$dest"
}

replicate ()
{
  if [ $# -eq 2 ] ; then
    flags=""
    snapname="$1"
    fs="$2"
  elif [ $# -eq 3 ] ; then
    flags="$1"
    snapname="$2"
    fs="$3"
  else
    echo "Function \`destroy_prev_snaps' recieved bad number of arguments." 1>&2
    exit 1
  fi

  if [ "${fs%%@*}" != "$fs" ] ; then
    echo "Filesystem name \`$fs' contains illegal character \`@'." 1>&2
    exit 1
  fi
  
  if [ -z "$flags" ] ; then
    zfs snapshot "${fs}@$snapname"
  else
    zfs snapshot "$flags" "${fs}@$snapname"
  fi

  dest="$( dest "$fs" )"
  prev_snap="$( zfs list -Ht snapshot | cut -f1 | egrep "^${dest}@" | tail -n1 || true )"
  if [ -z "$prev_snap" ] ; then
    n_match_prev=0
  else
    n_match_prev="$( echo "$prev_snap" | wc -l )"
  fi

  if [ "$n_match_prev" -eq 0 ] ; then
    zfs send -R "${fs}@$snapname" | zfs recv -u "$dest"
  elif [ "$n_match_prev" -eq 1 ] ; then
    prev_snap_fs="${prev_snap%%@*}"
    prev_snap_name="${prev_snap##*@}"
    
    if [ "${prev_snap_fs}@$prev_snap_name" != "${prev_snap}" ] ; then
      echo "Encountered illegal character \`@' in previous" \
           "snapshot name \`${prev_snap#*@}' of \`${prev_snap}'." 1>&2
      exit 1
    fi

    zfs send -Ri "@$prev_snap_name" "${fs}@$snapname" | zfs recv -u "$dest"
  else
    echo "Failed to get a unique match for most recent" \
         "replication of \`$fs'." 1>&2
    exit 1
  fi
}

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

zfs snapshot "zboss@$snapname"
destroy_prev_snaps zboss

replicate -r "$snapname" zroot
destroy_prev_snaps -r zroot
destroy_prev_snaps -r "$( dest zroot )"

replicate "$snapname" bootpool
destroy_prev_snaps bootpool
destroy_prev_snaps "$( dest bootpool )"

#replicate "$snapname" zcarry
#destroy_prev_snaps zcarry
#destroy_prev_snaps "$( dest zcarry )"
