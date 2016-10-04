# Install FreeBSD 11

Download the official FreeBSD 11.0-RC3 memory stick image [FreeBSD-11.0-RC3-amd64-memstick.img.xz](http://ftp.freebsd.org/pub/FreeBSD/releases/amd64/amd64/ISO-IMAGES/11.0/FreeBSD-11.0-RC3-amd64-memstick.img.xz) and write it on a USB memory stick. Replace `/dev/xxx` below with the path of the block device for the physical "drive" of your USB memory stick.

```bash
sudo umount /dev/xxx*

xzcat ~/Downloads/FreeBSD-11.0-RC3-amd64-memstick.img.xz \
  | sudo dd bs=16M of=/dev/xxx

sudo sync
```

Unplug the USB memory stick after the `sync` command has terminated.
Plug the USB memory stick into your ThinkPad T520 and power on the machine.

## Table of Contents

* [ThinkPad T520 BIOS Setup Utility](#thinkpad-t520-bios-setup-utility)
* [Boot from the FreeBSD 11.0-RC3 install media](#boot-from-the-freebsd-110-rc2-install-media)
* [Perform installation](#perform-installation)
* [Initial post-install configuration](#initial-post-install-configuration)

## ThinkPad T520 BIOS Setup Utility

At boot, press the blue "ThinkVantage"-button, causing it to show
a menu of options (it might also beep at this point).

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

## Boot from the FreeBSD 11.0-RC3 install media

At boot, press the blue "ThinkVantage"-button again.

Press F12 to select temporary startup device.

From the Boot Menu, select your USB memory stick.
In my case, it is called "USB HDD".

## Perform installation

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

Next, enter the hostname you want to use for your computer.
I think one is supposed to enter only the hostname here,
not the fully qualified domain name. I enter just the hostname.

Next it's time to select which optional system components to install.
Select *doc* and unselect *ports*. We'll be using my custom ports tree later.

Next it'll tell us that "Your model of Lenovo is known to have a BIOS
bug that prevents it booting from GPT partitions without UEFI. Would you
like the installer to apply a workaround for you?" Actually, most of all
we would like to boot using UEFI, so just say *No* here, I guess.

Now it's time to partition our disk. We'll select *Auto (ZFS)*, aka.
*Guided Root-on-ZFS*. It will tell us the choices it has made for us
and most of it is good. It has selected not to encrypt disks, which is
fine with me. It says that the *Partition Scheme* will be *GPT (BIOS+UEFI)*,
but we don't want that -- we change the *Partition Scheme* to *GPT (UEFI)*.
For *Swap Size*, we change it from *2g* to *8g* to match our amount of RAM.
All of the rest looks good for now, so we select *Install* to proceed
with the installation.

For *ZFS Configuration* of *Virtual Device type*, we select *stripe*,
since we only have one storage drive.

Next for *ZFS Configuration* it will ask for the devices to use.
Here we select our SSD. For me, it is named *ada0*. Use space to
select it and then press Enter to OK it.

Finally, it will give us one last chance to change our mind.
Why would we? Go ahead and destroy the current contents of
our selected disks. YES!

Then we wait for a while while it partitions the drive
and installs base, kernel, doc and lib32.

Next, enter a password for root. Well, our disk is unencrypted
anyway, so pick something simple like *hest123* and press Enter,
I guess.  (*Hest* is the Norwegian word for horse.)

Enter the password followed by Enter again.

Next, it wants us to configure a network interface.
I usually just go with a wired connection during installs,
so we select the "em0" interface.

Would we like to configure IPv4 for this interface. Yes.

Would we like to use DHCP to configure this interface? Sure.

It acquires DHCP lease.

Would we like to configure IPv6 for this interface? Well,
my current network does not support IPv6 but we'll say yes anyway.

Would we like to try stateless address autoconfiguration (SLAAC)?
Ok. It won't work on this network which does not support IPv6, though.

*Network Configuration* -- *Resolver Configuration* is next.
Since this is a laptop and will thus be on different networks
at various times, we're not going to bother with entering
any search domains. We just press Enter.

Is this machine's CMOS clock set to UTC? Yes, it is,
or at least it will be, so, yes.

Select a region. Probably you don't live the same place I do,
since the country I live in is so small. I select *Europe*
and then *Norway*.

It will ask if some time zone abbreviation looks reasonable.
For me at the current time of the year, this is *CEST*.
Yes, it looks reasonable.

Next, *Time & Date*, date part. The date is already set correctly
so I press Enter to accept that without changing it.

Next, *Time & Date*, time part. My clock is off by a couple of hours
so I attempted to choose *set time* but I guess I should have entered
a different value for it first. Oh well, I'll set it later.

Now it's time to choose the services we would like to be started
at boot. The default selection is *sshd* (good) and *dumpdev*.
I never inspected kernel crash dumps yet, so it is tempting to
uncheck that, but then again, if I ever need to have a look at it
in the future, the benefit of it being enabled so I don't have to
try and replicate the issue outweighs the cost of the disk space,
so we'll leave that selected as well. Next we'll select *ntpd*
to synchronize system and network time and I'll select *powerd*
to adjust CPU frequency dynamically, hoping that my hardware
is supported. We leave *moused* and *local_unbound* unchecked
and then press Enter to continue.

TODO: Investigate powerd support for my CPU.

Next up is the security hardening options. The ones we'll enable are:

 * *Randomize the PID of newly created processes*
 * *Insert stack guard page ahead of the growable segments*
 * *Clean the /tmp filesystem on system startup*
 * *Disable Sendmail service*

The remainder of the options seem to add nothing for a personal laptop.
As for our disabling the Sendmail service, that's actually just
because we want to install Postfix instead, not for security.

Select the options above using space and press Enter to continue.

Would we like to add users to the installed system now? Yes!

We type in the username. I call my user *erikn*.

We enter our full name. Mine is Erik Nordstrøm, but I'll enter Erik Nordstroem.

When prompted for a Uid, we'll just leave that empty for default.

Login group is named the same as your user, that's what we want.

Would we like to invite our user into other groups?
Yes, we'll enter *wheel operator*.

Login class default is fine.

Our shell can be sh for now. One of the first things we'll do
post-install is to install bash and change our shell to that.

Home directory default is fine as well.

Home directory permissions default is fine.

Use password-based authentication? Yes.

Use an empty password? No.

Use a random password? No.

Enter password. Pick something decent.

Enter the same password again.

Lock out the account after creation? No.

OK? Yes.

Add another user? No.

*Final configuration*. *Exit* -- apply configuration and exit installer.

Wait a little while for the configuration to be applied.

*Manual configuration*. "The installation is now finished. Before exiting
the installer, would you like to open a shell in the new system to make
any final manual modifications?" No, we'll take care of the rest on the
live system after reboot.

Installation of FreeBSD complete! Would we like to reboot
into the installed system now? Yes, please :)

## Initial post-install configuration

The system reboots. Log in as `root` using the password you selected.

We are eventually going to overwrite `/etc/rc.conf` but would like
to preserve the options we selected during bsdinstall. In order to do this,
we move our current `/etc/rc.conf` to `/etc/rc.conf.local`.

```sh
mv /etc/rc.conf /etc/rc.conf.local
```

Install `pkg`, `git`, `poudriere` and `beadm`.

```sh
env ASSUME_ALWAYS_YES=yes pkg bootstrap

pkg install git poudriere beadm
```

Create additional ZFS file systems for PostgreSQL data, PostgreSQL WAL
and Nginx data. The motivation for this is two-fold; firstly, having
user data on separate file systems makes it easier to backup, snapshot,
rollback, etc. this data independently from the rest of the system using
ZFS native features like `zfs send`, `zfs receive`, `zfs snapshot` and
`zfs rollback`, secondly, the OpenZFS wiki and other reliable resources
recommend having PostgreSQL's data and WAL on separate datasets with
recordsize=8K on both to avoid expensive partial record writes.
The OpenZFS wiki goes on to recommend setting logbias=throughput
on PostgreSQL's data to avoid writing twice.

```sh
zfs create -o mountpoint=/usr/local/pgsql/data -o recordsize=8K -o logbias=throughput zroot/pgdata

zfs create -o mountpoint=/usr/local/pgsql/data/pg_xlog -o recordsize=8K zroot/pgdata/wal

zfs create zroot/var/www
```

Snapshot your freshly installed system. Download and run the script
https://raw.githubusercontent.com/eriknstr/utils/master/snap.sh
using `fetch`, or just run `sh` and type in the following manually
or copy-paste it or whatever:

```sh
# You must use sh for this because the default shell
# for root on FreeBSD is csh and it has a different
# syntax for declaring variables.

snapname="$( date +%Y-%m-%d )-$( freebsd-version )-$( date +%s )"

zfs snapshot -r zroot@$snapname

zfs destroy -r zroot/tmp@$snapname
zfs destroy -r zroot/usr/ports@$snapname
zfs destroy -r zroot/usr/src@$snapname
zfs destroy -r zroot/var/audit@$snapname
zfs destroy -r zroot/var/crash@$snapname
zfs destroy -r zroot/var/log@$snapname
zfs destroy -r zroot/var/tmp@$snapname

exit
```

See also: http://open-zfs.org/wiki/Performance_tuning#PostgreSQL
