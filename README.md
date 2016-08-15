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

This guide assumes that your Lenovo ThinkPad T520 has a minimum of 8GB RAM,
and that it has a single storage drive; an SSD of at least X GB in size.
Note that this is different from the factory configuration which has
4GB RAM and a 7200-rpm 500GB HDD.

All commands in this README are to be performed as root unless otherwise noted.

TODO: Maintain system configs in repo ThinkPad-FreeBSD-src on branch stable/11.

TODO: Maintain most package options in repo ThinkPad-FreeBSD-ports on branch master.

![Screenshot of my desktop](https://raw.githubusercontent.com/eriknstr/freebsd-config/screenshots/screenshot.png)

## Install FreeBSD 11

Download the official FreeBSD 11.0-RC1 memory stick image [FreeBSD-11.0-RC1-amd64-memstick.img.xz](http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/amd64/ISO-IMAGES/11.0/FreeBSD-11.0-RC1-amd64-memstick.img.xz) and write it on a USB memory stick. Replace `/dev/xxx` below with the path of the path to the block device for the physical "drive" of your USB memory stick.

```bash
sudo umount /dev/xxx*

xzcat ~/Downloads/FreeBSD-11.0-RC1-amd64-memstick.img.xz \
  | sudo dd bs=16M of=/dev/xxx

sudo sync
```

Unplug the USB memory stick, plug it into your ThinkPad T520 and power on
the machine. Press the blue "ThinkVantage"-button, causing it to show
a menu of options (it might also beep at this point).

### ThinkPad T520 BIOS Setup Utility

Press F1 to enter the BIOS Setup Utility.

Navigate to the *Security* menu using the left and right arrow keys
of your keyborad. Select *Virtualization*. Ensure that
*Intel (R) Virtualization Technology* is set to *Enabled* and that
*Intel (R) VT-d Feature* is set to *Enabled*. Press Esc on your
keyboard to accept and go back to the previous menu. Under
*Memory Protection*, ensure *Execution Prevention* is *Enabled*.
Press Esc on your keyboard to go back to *Security* main menu.

TODO: Make use of the Security Chip. Google FreeBSD ThinkPad Security Chip.

Navigate to *Startup*. *Ensure UEFI/Legacy Boot* is set to *Both*
and that *UEFI/Legacy Boot Priority* is set to *UEFI First*.
Ensure *Boot device List F12 Option* is set to *Enabled*.
Next, go into the *Boot* section and ensure that the
*Boot Priority Order* list includes *USB FDD*, *USB HDD*
and *USB CD* somewhere in the list, as well as
*ATA HDD0* and *ATAPI CD0*. Any of these not in the list
must be moved up from *Excluded from boot priority order*.

There are a bunch of other settings worth checking out as well
but I won't list all of them here.

Press F10 to Save and Exit.

Press the blue "ThinkVantage"-button again.

Press F12 to select temporary startup device.

### Boot from the FreeBSD 11.0-RC1 install media

From the Boot Menu, select your USB memory stick.
In my case, it is called "USB HDD".

At the "Welcome to FreeBSD"-screen, press Enter or just wait.

Next, it'll say "Welcome to FreeBSD! Would you like to begin
an installation or use the live CD?" Select *Install* and press
Enter.

Make your *Keymap Selection*. I use the *United States of America dvorak*
keyboard layout (and so should you :). Use the up and down keyboard arrows
to go through the list and press Enter on the one you want to use.
Press Enter again to test the keymap. Type in some letters, numbers
and symbols. Then press Enter, press Enter again to select it and then
use the up keyboard arrow to continue with the keymap you have selected.

TODO: Remainder.

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
