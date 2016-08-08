# ThinkPad-FreeBSD-config

Configuration for FreeBSD 11 on Lenovo ThinkPad T520. Work in progress.

![Screenshot of my desktop](https://raw.githubusercontent.com/eriknstr/freebsd-config/screenshots/screenshot.png)

## Compile system from source using custom kernel config

First as your own regular user, do

```bash
cd
git clone -b stable/11 git@github.com:eriknstr/ThinkPad-FreeBSD-config.git
```

Next, perform the following steps as root. Replace ~erikn with
the path to the home dir of your own regular user.

```bash
cd /usr
git clone -b stable/11 git@github.com:eriknstr/freebsd.git
cd src
git remote add upstream git@github.com:freebsd/freebsd.git
cp ~erikn/src/github.com/eriknstr/freebsd-config/usr/src/sys/amd64/conf/T520 sys/amd64/conf/
sudo make buildworld buildkernel installkernel KERN_CONF=T520
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
