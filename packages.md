# Packages

```sh
pkg-static delete -f pkg
portsnap fetch extract
cd /usr/ports/ports-mgmt/pkg && make install clean
echo "DEFAULT_ALWAYS_YES = true;" >> /usr/local/etc/pkg.conf

pkg install doas
echo "permit nopass :wheel" >> /usr/local/etc/doas.conf

pkg install bash

pkg install neovim
ln -s /usr/local/bin/nvim /usr/local/bin/vim

pkg install git

pkg install htop

pkg install mate

pkg install xorg

pkg install xf86-video-intel

pkg install terminology

pkg install slim
echo slim_enable=yes >> /etc/rc.conf
```
