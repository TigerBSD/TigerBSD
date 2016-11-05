# ThinkPad-FreeBSD-setup

![Screenshot of my desktop](https://raw.githubusercontent.com/eriknstr/ThinkPad-FreeBSD-setup/screenshots-2016-11-02/screenshot.png)

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
and that it has two storage drives; each an SSD of at least 240GB in size.
Having two SSDs in the T520 is possible thanks to the [Caddy Adapter for T520
found on eBay](http://www.ebay.com/sch/i.html?_nkw=Caddy+Adapter+T520). Note
that this is quite different from the factory configuration which has
4GB RAM, a 7200-rpm 500GB HDD and a CD/DVD station. The assumption of the
storage medium being SSDs and not a HDD, in particular, is important,
since it will affect choices about how the OS is to treat the drive.
Things which make sense for a HDD might be slow for a SSD and vice versa.
Things which optimize the usage of a HDD might hurt an SSD and vice versa.

All commands in this README are to be performed as root unless otherwise noted.

![Photo of my caddy adapter next to the CD/DVD drive it replaced](https://raw.githubusercontent.com/eriknstr/ThinkPad-FreeBSD-setup/photos-2016-11-01/caddy.jpg)

## Table of Contents

* [Install FreeBSD 11](#install-freebsd-11)
* [Clone this repo under `root`](#clone-this-repo-under-root)
* [Compile customized system from source](#compile-customized-system-from-source)
  + [Compare changes local to ThinkPad-FreeBSD-src](#compare-changes-local-to-thinkpad-freebsd-src)
  + [Compare changes upstream not yet in ThinkPad-FreeBSD-src](#compare-changes-upstream-not-yet-in-thinkpad-freebsd-src)
* [Install cuse4bsd from latest sources](#install-cuse4bsd-from-latest-sources)
* [Install packages from FreeBSD repositories](#install-packages-from-freebsd-repositories)
* [Install custom configuration files](#install-custom-configuration-files)
* [Custom package builds using Poudriere](#custom-package-builds-using-poudriere)
  + [Build packages](#build-packages)
  + [Install packages](#install-packages)
  + [Install Rust](#install-rust)
  + [Install pip](#install-pip)
  + [Install matplotlib](#install-matplotlib)
  + [Upgrading pip and its packages](#upgrading-pip-and-its-packages)
  + [Compare changes local to ThinkPad-FreeBSD-ports](#compare-changes-local-to-thinkpad-freebsd-ports)
  + [Compare changes upstream not yet in ThinkPad-FreeBSD-ports](#compare-changes-upstream-not-yet-in-thinkpad-freebsd-ports)
* [User config](#user-config)
* [Connect external hardware](#connect-external-hardware)
  + [Apple iPod Touch](#apple-ipod-touch)
* [Troubleshooting](#troubleshooting)
  + [Unbootable system](#unbootable-system)
  + [Mount encrypted ZFS root using FreeBSD 11.0 Live CD](#mount-encrypted-zfs-root-using-freebsd-110-live-cd)

## Install FreeBSD 11

See [SYSINSTALL.md](/SYSINSTALL.md). Note that the install guide
includes several important steps which you need for your setup
to be correct so that the rest of this to work. Don't skip reading it.

## Clone this repo under `/root/`

```sh
git clone -b releng/11.0 https://github.com/eriknstr/ThinkPad-FreeBSD-setup.git \
  /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup

cd /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup/

git remote remove origin

git remote add origin git@github.com:eriknstr/ThinkPad-FreeBSD-setup.git
```

## Compile customized system from source

A fork of the FreeBSD source tree for use with Lenovo ThinkPad T520
is maintained at https://github.com/eriknstr/ThinkPad-FreeBSD-src

NOTE: At the time of this writing, no changes have yet been made by me to the FreeBSD sources. [Compare changes local to ThinkPad-FreeBSD-src](https://github.com/freebsd/freebsd/compare/releng/11.0...eriknstr:releng/11.0). Still, there is the custom kernel config so you might as well do this right away.

First time, do the following. Subsequent times, skip this step.

```sh
git clone -b releng/11.0 https://github.com/eriknstr/ThinkPad-FreeBSD-src.git \
  /usr/src

cd /usr/src/

git remote remove origin

git remote add origin git@github.com:eriknstr/ThinkPad-FreeBSD-src.git

git remote add upstream git@github.com:freebsd/freebsd.git

ln -s /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup/zroot/usr/src/sys/amd64/conf/T520 \
  sys/amd64/conf/T520

mkdir -p /opt/sbin/
cp /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup/zroot/opt/sbin/singleuser.sh \
  /opt/sbin/singleuser.sh
cp /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup/zroot/opt/sbin/snap.sh \
  /opt/sbin/snap.sh
```

Always snapshot the whole system at this point --
both the first time and all other times.

ZFS snapshots are very cheap thanks to COW (copy-on-write).

Take lots of snapshots, all of the time.

```sh
/opt/sbin/snap.sh
```

First time, skip the following. If this step says that you are up to date
then there is no point in rebuilding everything since you'd end up with
the same thing you already had.

```sh
cd /usr/src/

git pull
```

Reboot into single user mode, then

```sh
/opt/sbin/singleuser.sh

cd /usr/src/

time make buildworld
time make buildkernel KERNCONF=T520
time make installkernel KERNCONF=T520
```

At the time of this writing, buildworld takes approximately
four hours and twentyfive minutes on my ThinkPad T520,
buildkernel takes about 30 minutes, and finally, installkernel
takes on the order of seconds to complete.

Reboot into single user mode again and then

```sh
/opt/sbin/singleuser.sh

cd /usr/src/

mergemaster -p

time make installworld

mergemaster -iF

make delete-old
```

Installworld takes a little over a minute to complete.

Now reboot into multi user mode and then do

```sh
cd /usr/src/
make delete-old-libs
```

Finally, take another snapshot.

```sh
/opt/sbin/snap.sh
```

TODO: Package rebuilding in relation to delete-old-libs

See also:

 * https://www.freebsd.org/doc/handbook/kernelconfig-building.html
 * https://www.freebsd.org/doc/handbook/makeworld.html

### Compare changes local to ThinkPad-FreeBSD-src

https://github.com/freebsd/freebsd/compare/releng/11.0...eriknstr:releng/11.0

### Compare changes upstream not yet in ThinkPad-FreeBSD-src

https://github.com/eriknstr/ThinkPad-FreeBSD-src/compare/releng/11.0...freebsd:releng/11.0

## Install cuse4bsd from latest sources

```sh
cd

svnlite --username anonsvn --password anonsvn \
  checkout svn://svn.turbocat.net/i4b/trunk/usbcam/cuse4bsd

cd cuse4bsd

make all install
```

See also: http://www.selasky.org/hans_petter/cuse4bsd/

## Install packages from FreeBSD repositories

```sh
cd /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup/

cut -d'/' -f2 zroot/usr/local/etc/poudriere.d/11amd64-local-python35-pkglist \
  | env ASSUME_ALWAYS_YES=yes xargs -L1 pkg install

/opt/sbin/snap.sh

reboot
```

## Install custom configuration files

TODO: Maintain system configs in repo ThinkPad-FreeBSD-src on branch releng/11.0.

TODO: Maintain most package options in repo ThinkPad-FreeBSD-ports on branch master.

```sh
cd /root/src/github.com/eriknstr/ThinkPad-FreeBSD-setup/

./install.sh

cap_mkdb /etc/login.conf
```

Create swapfile directory for vim.

```sh
mkdir -p ~/.vim/swapfiles/
```

Enable failover link aggregation;

1. Remove the following from `/etc/rc.conf.local`:

   ```
   ifconfig_em0="DHCP"
   ifconfig_em0_ipv6="inet6 accept_rtadv"
   ```

2. Replace the following in `/etc/rc.conf`:

   ```
   wlans_iwn0="wlan0"
   ifconfig_wlan0="DHCP WPA country NO"
   
   #
   ##  em0 real MAC: aa:aa:aa:aa:aa:aa
   ## iwn0 real MAC: bb:bb:bb:bb:bb:bb
   #
   #ifconfig_em0="ether bb:bb:bb:bb:bb:bb up"
   #wlans_iwn0="wlan0"
   #ifconfig_wlan0="WPA country NO"
   #cloned_interfaces="lagg0"
   #ifconfig_lagg0="laggproto failover laggport em0 laggport wlan0 DHCP"
   #
   ```

   with:

   ```
   #wlans_iwn0="wlan0"
   #ifconfig_wlan0="DHCP WPA country NO"
   
   
   #  em0 real MAC: aa:aa:aa:aa:aa:aa
   # iwn0 real MAC: bb:bb:bb:bb:bb:bb
   
   ifconfig_em0="ether bb:bb:bb:bb:bb:bb up"
   wlans_iwn0="wlan0"
   ifconfig_wlan0="WPA country NO"
   cloned_interfaces="lagg0"
   ifconfig_lagg0="laggproto failover laggport em0 laggport wlan0 DHCP"
   
   ```

   while at the same time also replacing the values of
   `aa:aa:aa:aa:aa:aa` and `bb:bb:bb:bb:bb:bb` with the actual
   values reported by ifconfig for each of em0 and iwn0.

   Also, replace the country code set for wlan0 with
   that of your country.

Finalize WLAN configuration. You'll need to enter SSID and credentials.

`/etc/wpa_supplicant.conf.sample` contains sample entries for
two networks; *eduroam* and *mysweetwifi*. Copy the file sample file
to `/etc/wpa_supplicant.conf` and edit `/etc/wpa_supplicant.conf`
as described below.

```sh
cp /etc/wpa_supplicant.conf.sample /etc/wpa_supplicant.conf
```

If you are a student, a researcher or an educator at an
eduroam-connected institution, edit the *eduroam* entry substituting
the values of *identity* and *password* with those provided to you
by your institution. The *eduroam* network configuration might require
additional changes depending on how the network is set up at the physical
location where you are attempting to connect.

If you do not have an account for *eduroam*, you can remove the entry.

Replace the *mysweetwifi* entry providing the *ssid* and *psk*
of an actual WPA- or WPA2-protected WiFi network if any, otherwise
remove it.  Whenever you need to connect to another WPA- or
WPA2-protected network, create a new entry for it in
`/etc/wpa_supplicant.conf`.

With that done, take another snapshot again.

```sh
/opt/sbin/snap.sh
```

Note: Until issue #22 has been resolved, you will
need to run the following two commands

```sh
service dhclient restart lagg0
service netif restart lagg0
```

when connection state changes if wireless and wired are
on different networks or routers.

## Custom package builds using Poudriere

A fork of the FreeBSD ports tree for use with Lenovo ThinkPad T520
is maintained at https://github.com/eriknstr/ThinkPad-FreeBSD-ports

TODO: Create jail from customized FreeBSD build
instead of using the official release files.

```sh
poudriere jail -c -j 11amd64 -v 11.0-RELEASE

poudriere ports -c -F -p local

git clone https://github.com/eriknstr/ThinkPad-FreeBSD-ports.git \
  /usr/local/poudriere/ports/local

cd /usr/local/poudriere/ports/local/

git remote remove origin

git remote add origin git@github.com:eriknstr/ThinkPad-FreeBSD-ports.git

git remote add upstream git@github.com:freebsd/freebsd-ports.git

mkdir /usr/ports/distfiles/

/opt/sbin/snap.sh
```

See also: https://www.freebsd.org/doc/handbook/ports-poudriere.html

### Build packages

This step is not of interest to most people until issue #20 has been resolved.

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

### Install packages

This step has been temporarily removed until issue #20 has been resolved.

### Install Rust

https://rustup.rs/

### Install pip

```sh
python3.5 -m ensurepip
python2.7 -m ensurepip
```

### Install matplotlib

```sh
pip3.5 install matplotlib
```

### Upgrading pip and its packages

```sh
pip3.5 install -U pip
pip3.5 freeze --local | grep -v '^\-e' | cut -d'=' -f1 \
  | xargs -n1 pip3.5 install -U
```

```sh
pip2.7 install -U pip
pip2.7 freeze --local | grep -v '^\-e' | cut -d'=' -f1 \
  | xargs -n1 pip2.7 install -U
```

### Compare changes local to ThinkPad-FreeBSD-ports

https://github.com/freebsd/freebsd-ports/compare/master...eriknstr:master

### Compare changes upstream not yet in ThinkPad-FreeBSD-ports

https://github.com/eriknstr/ThinkPad-FreeBSD-ports/compare/master...freebsd:master

## User config

Perform the following commands as your own user.

```sh
doas pw groupmod vboxusers -m $USER
```

## Connect external hardware

### Apple iPod Touch

```sh
mkdir -p /media/ipod
usbmuxd -f
```

Connect your iPod Touch using the USB cable.

Confirm the pop-up on the iPod asking to trust computer.

In another terminal.

```sh
ifuse -o allow_other /media/ipod
```

## Troubleshooting

### Unbootable system

In case an upgrade (`make buildworld buildkernel installkernel KERNCONF=T520`,
`make installworld` and so on) goes bad and renders the system unable to boot,
~~try selecting your previous boot environment from the beastie boot menu~~
*until issue #15 has been resolved, use "Live CD" as mentioned described
below to try and fix things yourself*.

~~If that doesn't help, boot the install media and use the "Live CD" as
described below to try and fix things yourself.~~

### Mount encrypted ZFS root using FreeBSD 11.0 "Live CD"

Boot the FreeBSD 11.0 install media and select "Live CD", then;

```sh
zpool import
zpool import -fR /tmp bootpool

geli attach -k /tmp/bootpool/boot/encryption.key /dev/ada0p4
geli attach -k /tmp/bootpool/boot/encryption.key /dev/ada1p4

zpool import
zpool import -fR /mnt zroot
zfs mount zroot/ROOT/default
zfs mount -a
```

At this point, probably the first thing you should do is to
backup your data to a safe location before you continue.
Remember to verify that your backup is good. From there on,
what you need to do will depend on what is your problem
and how recently you last took a snapshot.

If the only changes you've made since last snapshot are
the kind of changes that don't matter if get lost and
you are *really* sure that such is the case, probably
`zfs rollback` (see `zfs(1)`) is the best course of action.

Once done, export the pools and then reboot.

```sh
cd
zpool export zroot
zpool export bootpool
reboot
```
