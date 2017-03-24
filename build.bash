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
set -o pipefail

MAKE=make

# Get source directory of script. http://stackoverflow.com/a/246128
self="${BASH_SOURCE[0]}"
dir=
while [ -h "${dir}" ] ; do
  dir="$( cd -P "$( dirname "${dir}" )" && pwd )"
  self="$( readlink "${self}" )"
  [[ ${self} != /* ]] && self="${dir}/${self}" # for relative symlinks
done
dir="$( cd -P "$( dirname "${self}" )" && pwd )"

vars=
makeargs=

vars+=" MAKEOBJDIRPREFIX=\"$dir/build/\""
vars+=" DESTDIR=\"$dir/out/\""

makeargs+=" -DNO_CLEAN"
makeargs+=" KERNCONF=THINKPAD"

kernconfsrcdir="src/kernconf/"
kernconfdestdir="FreeBSD/sys/amd64/conf/"
for kernconf in BAREMIN T520 X220TABLET THINKPAD ; do
  if [ ! -f "${kernconfdestdir}/${kernconf}" ] || ! cmp "${kernconfdestdir}/${kernconf}" "${kernconfsrcdir}/${kernconf}" ; then
    echo "cp \"${kernconfsrcdir}/${kernconf}\" \"${kernconfdestdir}/${kernconf}\"" 1>&2
    cp "${kernconfsrcdir}/${kernconf}" "${kernconfdestdir}/${kernconf}"
  fi
done

cd "$dir/FreeBSD"

invoked ()
{
  echo "${0}: Command was: env -i ${vars} ${MAKE} ${makeargs} ${@}" 1>&2
}

trap invoked EXIT

# XXX: The FreeBSD main Makefile is configured to fail if no target is given,
#      so we don't bother checking that our script was given any arguments.
env -i ${vars} make ${makeargs} ${@}

trap - EXIT
