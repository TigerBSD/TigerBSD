# ThinkPad-FreeBSD-config

Configuration for FreeBSD 11 on Lenovo ThinkPad T520. Work in progress.
Please have a look at the list of
[open issues](https://github.com/eriknstr/ThinkPad-FreeBSD-config/issues),
but do also be aware that even if none are open, there could be things
that are broken or incomplete still.

All commands in this README are to be performed as root unless otherwise noted.

![Screenshot of my desktop](https://raw.githubusercontent.com/eriknstr/freebsd-config/screenshots/screenshot.png)

## Install FreeBSD 11

TODO: Document choices made.

## Install custom configuration files

```bash
pkg bootstrap

pkg install git

mkdir -p /root/src/github.com/eriknstr/

cd /root/src/github.com/eriknstr/

git clone -b stable/11 git@github.com:eriknstr/ThinkPad-FreeBSD-config.git

cd ThinkPad-FreeBSD-config

./install.sh
```

## Compile system from source using custom kernel config

First time, do the following. Subsequent times, skip this step.

```bash
cd /usr

git clone -b stable/11 git@github.com:eriknstr/freebsd.git src

cd src

git remote add upstream git@github.com:freebsd/freebsd.git

ln -s /root/src/github.com/eriknstr/ThinkPad-FreeBSD-config/zroot/usr/src/sys/amd64/conf/T520 \
  sys/amd64/conf/T520
```

First time, skip this step. Subsequent times, start with this step.
If this step says that you are up to date then there is no point
in rebuilding everything since you'd end up with the same thing
you already had.

```bash
cd /usr/src

git pull
```

Reboot into single user mode, then

```bash
/singleuser.sh

make buildworld buildkernel installkernel KERN_CONF=T520

mergemaster -p

cd /usr/src

make installworld

mergemaster -iF

make delete-old

reboot
```

Finally, do

```bash
make delete-old-libs
```

TODO: Package rebuilding in relation to delete-old-libs

See also: https://www.freebsd.org/doc/handbook/makeworld.html

## Poudriere package builds

```bash
pkg install poudriere

poudriere jail -c -j 11amd64 -v 11.0-ALPHA6

cd /usr/local/poudriere/ports/

git clone git@github.com:eriknstr/freebsd-ports.git local

cd local

git remote add upstream git@github.com:freebsd/freebsd-ports.git

poudriere options -j 11amd64 -p local -z python35 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python35-pkglist

poudriere bulk -j 11amd64 -p local -z python35 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python35-pkglist

poudriere options -j 11amd64 -p local -z python34 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python34-pkglist

poudriere bulk -j 11amd64 -p local -z python34 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python34-pkglist

poudriere options -j 11amd64 -p local -z python27 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python27-pkglist

poudriere bulk -j 11amd64 -p local -z python27 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python27-pkglist
```

See also: https://www.freebsd.org/doc/handbook/ports-poudriere.html

### Installing the packages

```bash
cut -d'/' -f2 /usr/local/etc/poudriere.d/11amd64-local-python35-pkglist \
  | xargs -L1 pkg install
```

(We run the install one package at a time so that a missing package
 won't stop the installation of all the other, unrelated packages.)

### Updating poudriere ports tree and packages

```bash
cd /usr/local/poudriere/ports/local/

git pull

poudriere options -j 11amd64 -p local -z python35 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python35-pkglist

poudriere bulk -j 11amd64 -p local -z python35 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python35-pkglist

poudriere options -j 11amd64 -p local -z python34 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python34-pkglist

poudriere bulk -j 11amd64 -p local -z python34 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python34-pkglist

poudriere options -j 11amd64 -p local -z python27 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python27-pkglist

poudriere bulk -j 11amd64 -p local -z python27 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python27-pkglist
```
