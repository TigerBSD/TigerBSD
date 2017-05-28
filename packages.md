# Packages

```sh
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
Xorg -configure
#Xorg -config /root/xorg.conf.new
mv xorg.conf.new /usr/local/etc/X11/xorg.conf.d/0-xorg.conf
cat > /usr/local/etc/X11/xorg.conf.d/20-dvorak.conf <<EOF
Section "ServerFlags"
	Option  "AutoAddDevices" "Off"
EndSection

Section "InputDevice"
	Identifier "Keyboard0"
	Driver  "kbd"
	Option  "XkbLayout" "dvorak"
EndSection
EOF
echo "ssh-agent mate-session" > ~erikn/.xinitrc
chown erikn:erikn ~erikn/.xinitrc
chmod 755 ~erikn/.xinitrc

pkg install xf86-video-intel

pkg install terminology

pkg install slim
echo slim_enable=yes >> /etc/rc.conf
```
