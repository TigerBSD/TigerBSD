# ThinkPad-FreeBSD-setup

Customized FreeBSD 11 for Lenovo ThinkPad T520. Work in progress.
Please have a look at the list of
[open issues for this repository](https://github.com/eriknstr/ThinkPad-FreeBSD-setup/issues),
as well as the lists of
[open issues for ThinkPad-FreeBSD-ports](https://github.com/eriknstr/ThinkPad-FreeBSD-ports/issues)
and
[open issues for ThinkPad-FreeBSD-src](https://github.com/eriknstr/ThinkPad-FreeBSD-src/issues),
but do also be aware that even if none are open, there could be things
that are broken or incomplete still.

All commands in this README are to be performed as root unless otherwise noted.

TODO: Maintain system configs in repo ThinkPad-FreeBSD-src on branch stable/11.

TODO: Maintain most package options in repo ThinkPad-FreeBSD-ports on branch master.

![Screenshot of my desktop](https://raw.githubusercontent.com/eriknstr/freebsd-config/screenshots/screenshot.png)

## Install FreeBSD 11

Download the official FreeBSD 11.0-RC1 memory stick image [FreeBSD-11.0-RC1-amd64-memstick.img.xz](ftp://ftp.freebsd.org/pub/FreeBSD/releases/amd64/amd64/ISO-IMAGES/11.0/FreeBSD-11.0-RC1-amd64-memstick.img.xz) and write it on a USB memory stick using `dd` or similar. Insert the USB memory stick into your ThinkPad T520 and boot from it.

TODO: Document choices made.

Finally, set the hostname in file `/etc/rc.conf.local`, e.g.:

```sh
echo 'hostname="liberation"' > /etc/rc.conf.local
```

## Install custom configuration files

```sh
pkg bootstrap

pkg install git

mkdir -p /root/src/github.com/eriknstr/

cd /root/src/github.com/eriknstr/

git clone -b stable/11 git@github.com:eriknstr/ThinkPad-FreeBSD-setup.git

cd ThinkPad-FreeBSD-setup

./install.sh
```

## Compile customized system from source

First time, do the following. Subsequent times, skip this step.

```sh
cd /usr

git clone -b stable/11 git@github.com:eriknstr/ThinkPad-FreeBSD-src.git src

cd src

git remote add upstream git@github.com:freebsd/freebsd.git

ln -s /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup/zroot/usr/src/sys/amd64/conf/T520 \
  sys/amd64/conf/T520
```

First time, skip this step. Subsequent times, start with this step.
If this step says that you are up to date then there is no point
in rebuilding everything since you'd end up with the same thing
you already had.

```sh
cd /usr/src

git pull
```

Reboot into single user mode, then

```sh
/singleuser.sh

cd /usr/src

make buildworld buildkernel installkernel KERNCONF=T520
```

A full buildworld buildkernel takes about five hours
on my ThinkPad T520 at the time of this writing.
Out of this, the time taken by the buildkernel step
alone is about 50 minutes.

Reboot into single user mode again and then

```sh
/singleuser.sh

cd /usr/src

mergemaster -p

make installworld

mergemaster -iF

make delete-old
```

Finally, reboot into multi user mode and then do

```sh
make delete-old-libs
```

TODO: Package rebuilding in relation to delete-old-libs

See also:

 * https://www.freebsd.org/doc/handbook/kernelconfig-building.html
 * https://www.freebsd.org/doc/handbook/makeworld.html

### Compare changes upstream not yet in ThinkPad-FreeBSD-src

https://github.com/eriknstr/ThinkPad-FreeBSD-src/compare/stable/11...freebsd:stable/11

## Custom package builds using Poudriere

TODO: Create jail from customized FreeBSD build
instead of using the official release files.

```sh
pkg install poudriere

poudriere jail -c -j 11amd64 -v 11.0-RC1

cd /usr/local/poudriere/ports/

git clone git@github.com:eriknstr/ThinkPad-FreeBSD-ports.git local

cd local

git remote add upstream git@github.com:freebsd/freebsd-ports.git

poudriere bulk -j 11amd64 -p local -z python35 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python35-pkglist

poudriere bulk -j 11amd64 -p local -z python34 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python34-pkglist

poudriere bulk -j 11amd64 -p local -z python27 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python27-pkglist
```

See also: https://www.freebsd.org/doc/handbook/ports-poudriere.html

### Installing the packages

```sh
cut -d'/' -f2 /usr/local/etc/poudriere.d/11amd64-local-python35-pkglist \
  | xargs -L1 pkg install
```

(We run the install one package at a time so that a missing package
 won't stop the installation of all the other, unrelated packages.)

### Updating Poudriere ports tree and packages

```sh
cd /usr/local/poudriere/ports/local/

git pull

poudriere bulk -j 11amd64 -p local -z python35 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python35-pkglist

poudriere bulk -j 11amd64 -p local -z python34 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python34-pkglist

poudriere bulk -j 11amd64 -p local -z python27 \
  -f /usr/local/etc/poudriere.d/11amd64-local-python27-pkglist
```

### Keeping an eye on Poudriere builds from other computers

```sh
cd /usr/local/poudriere/data/logs/bulk
doas -u www python3.5 -m http.server
```

### Compare changes upstream not yet in ThinkPad-FreeBSD-ports

https://github.com/eriknstr/ThinkPad-FreeBSD-ports/compare/master...freebsd:master
