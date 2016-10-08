# ThinkPad-FreeBSD-setup

Setup of customized FreeBSD 11 for Lenovo ThinkPad T520. Work in progress.
Please have a look at the following few links:

* [Open issues for this repository](https://github.com/eriknstr/ThinkPad-FreeBSD-setup/issues)
* [Open issues for ThinkPad-FreeBSD-src](https://github.com/eriknstr/ThinkPad-FreeBSD-src/issues)
* [Open issues for ThinkPad-FreeBSD-ports](https://github.com/eriknstr/ThinkPad-FreeBSD-ports/issues)

Be aware that even if no issues are open for any of these three repositories,
there could be things that are broken or incomplete still. As [was once
said by someone on the OpenBSD mailing lists](http://marc.info/?l=openbsd-misc&m=145358748924473&w=4);

>Customization breeds bugs and hurts interoperability.

With that out of the way, let's get on with it.

This guide assumes that your Lenovo ThinkPad T520 has a minimum of 8GB RAM,
and that it has a single storage drive; an SSD of at least 120GB in size.
Note that this is different from the factory configuration which has
4GB RAM and a 7200-rpm 500GB HDD. The assumption of the storage medium
being an SSD and not a HDD, in particular, is important, since it will
affect choices about how the OS is to treat the drive. Things which
make sense for a HDD might be slow for a SSD and vice versa.
Things which optimize the usage of a HDD might hurt an SSD and vice versa.

All commands in this README are to be performed as root unless otherwise noted.

![Screenshot of my desktop](https://raw.githubusercontent.com/eriknstr/ThinkPad-FreeBSD-setup/screenshots-2016-08-26/screenshot.png)

## Table of Contents

* [Install FreeBSD 11](#install-freebsd-11)
* [Clone this repo under `root`](#clone-this-repo-under-root)
* [Compile customized system from source](#compile-customized-system-from-source)
  + [Compare changes local to ThinkPad-FreeBSD-src](#compare-changes-local-to-thinkpad-freebsd-src)
  + [Compare changes upstream not yet in ThinkPad-FreeBSD-src](#compare-changes-upstream-not-yet-in-thinkpad-freebsd-src)
* [Install cuse4bsd from latest sources](#install-cuse4bsd-from-latest-sources)
* [Install custom configuration files](#install-custom-configuration-files)
* [Custom package builds using Poudriere](#custom-package-builds-using-poudriere)
  + [Installing the packages](#installing-the-packages)
  + [Updating Poudriere ports tree and packages](#updating-poudriere-ports-tree-and-packages)
  + [Compare changes local to ThinkPad-FreeBSD-ports](#compare-changes-local-to-thinkpad-freebsd-ports)
  + [Compare changes upstream not yet in ThinkPad-FreeBSD-ports](#compare-changes-upstream-not-yet-in-thinkpad-freebsd-ports)
* [Troubleshooting](#troubleshooting)
  + [Unbootable system](#unbootable-system)
  + [Mount plain ZFS root using FreeBSD 11.0 Live CD](#mount-plain-zfs-root-using-freebsd-110-live-cd)
  + [Mount encrypted ZFS root using FreeBSD 11.0 Live CD](#mount-encrypted-zfs-root-using-freebsd-110-live-cd)

## Install FreeBSD 11

See [SYSINSTALL.md](/SYSINSTALL.md). Note that the install guide
includes several important steps which you need for your setup
to be correct so that the rest of this to work. Don't skip reading it.

## Clone this repo under `/root/`

```sh
git clone -b stable/11 git@github.com:eriknstr/ThinkPad-FreeBSD-setup.git \
  /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup
```

## Compile customized system from source

A fork of the FreeBSD source tree for use with Lenovo ThinkPad T520
is maintained at https://github.com/eriknstr/ThinkPad-FreeBSD-src

NOTE: At the time of this writing, no changes have yet been made by me to the FreeBSD sources. [Compare changes local to ThinkPad-FreeBSD-src](https://github.com/freebsd/freebsd/compare/stable/11...eriknstr:stable/11). Still, there is the custom kernel config so you might as well do this right away.

First time, do the following. Subsequent times, skip this step.

```sh
git clone -b stable/11 git@github.com:eriknstr/ThinkPad-FreeBSD-src.git \
  /usr/src

cd /usr/src/

git remote add upstream git@github.com:freebsd/freebsd.git

ln -s /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup/zroot/usr/src/sys/amd64/conf/T520 \
  sys/amd64/conf/T520

ln -s /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup/zroot/singleuser.sh \
  /singleuser.sh
```

First time, skip this step. Subsequent times, start with this step.
If this step says that you are up to date then there is no point
in rebuilding everything since you'd end up with the same thing
you already had.

```sh
cd /usr/src/

git pull
```

Create and activate a new boot environment. Boot environments allow you
to easily roll back to the previous version in case the upgrade goes bad.
The commands below assume that you are using a `sh`-compatible shell,
such as for example `sh` or `bash`.

```sh
cd /usr/src/

nextenv="11.0-$( date +%Y%m%d )-g$( git rev-parse --short HEAD )"

beadm create $nextenv

beadm activate $nextenv
```

Reboot into single user mode, then

```sh
/singleuser.sh

cd /usr/src/

make buildworld buildkernel installkernel KERNCONF=T520
```

At the time of this writing, buildworld takes approximately
three and a half hours on my ThinkPad T520, and buildkernel
takes about half an hour.

Reboot into single user mode again and then

```sh
/singleuser.sh

cd /usr/src/

mergemaster -p

make installworld

mergemaster -iF

make delete-old
```

Now reboot into multi user mode and then do

```sh
cd /usr/src/
make delete-old-libs
```

Finally, take another snapshot. ZFS snapshots are very cheap
thanks to COW (copy-on-write).

Take lots of snapshots, all of the time.

TODO: Package rebuilding in relation to delete-old-libs

See also:

 * https://www.freebsd.org/doc/handbook/kernelconfig-building.html
 * https://www.freebsd.org/doc/handbook/makeworld.html

### Compare changes local to ThinkPad-FreeBSD-src

https://github.com/freebsd/freebsd/compare/stable/11...eriknstr:stable/11

### Compare changes upstream not yet in ThinkPad-FreeBSD-src

https://github.com/eriknstr/ThinkPad-FreeBSD-src/compare/stable/11...freebsd:stable/11

## Install cuse4bsd from latest sources

```sh
cd

svnlite --username anonsvn --password anonsvn \
  checkout svn://svn.turbocat.net/i4b/trunk/usbcam/cuse4bsd

cd cuse4bsd

make all install
```

See also: http://www.selasky.org/hans_petter/cuse4bsd/

## Install custom configuration files

TODO: Maintain system configs in repo ThinkPad-FreeBSD-src on branch stable/11.

TODO: Maintain most package options in repo ThinkPad-FreeBSD-ports on branch master.

```sh
cd /root/src/github.com/ThinkPad-FreeBSD-setup/

./install.sh

cap_mkdb /etc/login.conf
```

Configure WLAN. Most of it is taken care of by the installed files,
but you'll need to enter information about network SSID and PSK.
If your SSID was *mysweetwifi* and your PSK was *supersecret*,
then you'd add the following contents to the file `/etc/wpa_supplicant.conf`:

```
network={
	ssid="mysweetwifi"
	psk="supersecret"
}
```

With that done, take another snapshot again.

## Custom package builds using Poudriere

A fork of the FreeBSD ports tree for use with Lenovo ThinkPad T520
is maintained at https://github.com/eriknstr/ThinkPad-FreeBSD-ports

TODO: Create jail from customized FreeBSD build
instead of using the official release files.

```sh
poudriere jail -c -j 11amd64 -v 11.0-RC3

poudriere ports -c -F -p local

git clone git@github.com:eriknstr/ThinkPad-FreeBSD-ports.git \
  /usr/local/poudriere/ports/local

cd /usr/local/poudriere/ports/local/

git remote add upstream git@github.com:freebsd/freebsd-ports.git

mkdir /usr/ports/distfiles/

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

### Installing pip

```sh
python3.5 -m ensurepip
python3.4 -m ensurepip
python2.7 -m ensurepip
```

### Installing matplotlib

```sh
pip3.5 install matplotlib
```

### Upgrading pip and its packages

```sh
pip3.5 install -U pip
pip3.5 freeze --local | grep -v '^\-e' | cut -d'=' -f1 \
  | xargs -n1 pip3.5 install -U

pip3.4 install -U pip
pip3.4 freeze --local | grep -v '^\-e' | cut -d'=' -f1 \
  | xargs -n1 pip3.4 install -U

pip2.7 install -U pip
pip2.7 freeze --local | grep -v '^\-e' | cut -d'=' -f1 \
  | xargs -n1 pip2.7 install -U
```

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

### Compare changes local to ThinkPad-FreeBSD-ports

https://github.com/freebsd/freebsd-ports/compare/master...eriknstr:master

### Compare changes upstream not yet in ThinkPad-FreeBSD-ports

https://github.com/eriknstr/ThinkPad-FreeBSD-ports/compare/master...freebsd:master

## Troubleshooting

### Unbootable system

In case an upgrade (`make buildworld buildkernel installkernel KERNCONF=T520`,
`make installworld` and so on) goes bad and renders the system unable to boot,
try selecting your previous boot environment from the beastie boot menu.

If that doesn't help, boot the install media and use the "Live CD" as
described below to try and fix things yourself.

### Mount plain ZFS root using FreeBSD 11.0 "Live CD"

First, boot the FreeBSD 11.0 install media and select "Live CD".
Next, mount the ZFS root on `/mnt`;

```sh
zpool import
zpool import -fR /mnt zroot
zfs mount zroot/ROOT/default
zfs mount -a
```

At this point, probably the first thing you should do is to
backup your data to a safe location before you continue.
Remember to verify that your backup is good.

### Mount encrypted ZFS root using FreeBSD 11.0 "Live CD"

Same as above, except that the following
set of commands are to be used instead;

```sh
zpool import
zpool import -fR /tmp bootpool

geli attach -k /tmp/bootpool/boot/encryption.key /dev/ada0p4

zpool import
zpool import -fR /mnt zroot
zfs mount zroot/ROOT/default
zfs mount -a
```
