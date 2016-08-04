# freebsd-config

Configuration for FreeBSD 11 on Lenovo ThinkPad T520.

![Screenshot of my desktop](https://raw.githubusercontent.com/eriknstr/freebsd-config/screenshots/screenshot.png)

## Poudriere

```bash
sudo poudriere options -j 11amd64 -p local -z default_python -f /usr/local/etc/poudriere.d/11amd64-local-default_python-pkglist 
sudo poudriere bulk -j 11amd64 -p local -z default_python -f /usr/local/etc/poudriere.d/11amd64-local-default_python-pkglist
```
