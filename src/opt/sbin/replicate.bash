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

set -eu

if [ $# -eq 0 ] ; then
  snapname="$( /opt/bin/snapname.sh )"
elif [ $# -eq 1 ] ; then
  snapname="$1"
else
  echo "Usage: $0 [snapname]" 1>&2
  exit 1
fi

prev_snap="$( zfs list -H -t snapshot | egrep '^zboss/dupli/lul@' | tail -n1 | cut -f1 | cut -b17- )"

zfs snapshot -r "zcarry@$snapname"

zfs send -i "$prev_snap" "zcarry@$snapname" | zfs recv zboss/dupli/lul
