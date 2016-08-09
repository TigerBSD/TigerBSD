# ThinkPad-FreeBSD-config

Configuration for FreeBSD 11 on Lenovo ThinkPad T520. Work in progress.

![Screenshot of my desktop](https://raw.githubusercontent.com/eriknstr/freebsd-config/screenshots/screenshot.png)

## Install FreeBSD 11

TODO: Document choices made.

## Install customizations

Perform the following as the root user.

```bash
pkg bootstrap

pkg install git

mkdir -p /root/src/github.com/eriknstr/

cd /root/src/github.com/eriknstr/

git clone -b stable/11 git@github.com:eriknstr/ThinkPad-FreeBSD-config.git
```

## Compile system from source using custom kernel config

```bash
cd /usr
git clone -b stable/11 git@github.com:eriknstr/freebsd.git src
cd src
git remote add upstream git@github.com:freebsd/freebsd.git
ln -s /root/src/github.com/eriknstr/freebsd-config/usr/src/sys/amd64/conf/T520 sys/amd64/conf/T520
make buildworld buildkernel installkernel KERN_CONF=T520
```

Reboot into single user mode, then

TODO: Describe the rest. Don't have time now.

## Poudriere package builds

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

### Installing the packages

Perform the following command as root.

```bash
cut -d'/' -f2 /usr/local/etc/poudriere.d/11amd64-local-default_python-pkglist \
  | xargs -L1 pkg install
```

(We run the install one package at a time so that a missing package
 won't stop the installation of all the other, unrelated packages.)

### Updating poudriere ports tree and packages

Perform the following commands as root.

```bash
cd /usr/local/poudriere/ports/local/

git pull

poudriere options -j 11amd64 -p local -z default_python \
  -f /usr/local/etc/poudriere.d/11amd64-local-default_python-pkglist

poudriere bulk -j 11amd64 -p local -z default_python \
  -f /usr/local/etc/poudriere.d/11amd64-local-default_python-pkglist
```
