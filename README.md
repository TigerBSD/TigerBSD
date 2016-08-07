# ThinkPad-FreeBSD-config

Configuration for FreeBSD 11 on Lenovo ThinkPad T520.

![Screenshot of my desktop](https://raw.githubusercontent.com/eriknstr/freebsd-config/screenshots/screenshot.png)

## Poudriere

Perform the following commands as root.

```bash
poudriere jail -c -j 11amd64 -v 11.0-ALPHA6

poudriere ports -c -p local -m git

poudriere options -j 11amd64 -p local -z default_python \
  -f /usr/local/etc/poudriere.d/11amd64-local-default_python-pkglist

poudriere bulk -j 11amd64 -p local -z default_python \
  -f /usr/local/etc/poudriere.d/11amd64-local-default_python-pkglist
```

See also: https://www.freebsd.org/doc/handbook/ports-poudriere.html

## /usr/src

```bash
cd /usr
git clone -b stable/11 git@github.com:eriknstr/freebsd.git
cd src
git remote add upstream git@github.com:freebsd/freebsd.git
cp ~/src/github.com/eriknstr/freebsd-config/usr/src/sys/amd64/conf/T520 sys/amd64/conf/
sudo make buildworld buildkernel installkernel KERN_CONF=T520
```

Reboot into single user mode, then

TODO: Describe the rest. Don't have time now.
