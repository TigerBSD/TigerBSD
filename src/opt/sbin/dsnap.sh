#!/usr/bin/env sh

#
# Copyright (c) 2017, 2017 Erik Nordstrøm <erik@nordstroem.no>
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

#echo "Oh *HELL* NO!" 1>&2
#exit 1

zfs list -H -t snapshot | egrep '^bootpool@' | cut -f1 \
  | xargs -L1 zfs destroy -r

zfs list -H -t snapshot | egrep '^zroot@' | cut -f1 | xargs -L1 zfs destroy -r

#zfs list -H -t snapshot | egrep '^zboss@' | cut -f1 | xargs -L1 zfs destroy
