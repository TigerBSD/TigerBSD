# Packages

```sh
pkg-static delete -f pkg
portsnap fetch extract
cd /usr/ports/ports-mgmt/pkg && make install clean

pkg install doas
cat >/usr/local/etc/doas.conf <<EOF
permit nopass :wheel
EOF

pkg install bash

pkg install neovim
ln -s /usr/local/bin/nvim /usr/local/bin/vim

pkg install mate
```
