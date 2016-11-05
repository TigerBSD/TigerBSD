#!/usr/bin/env sh

err_invdir="Invalid directory. Was script path resolved using \$PATH? Don't."

exit_error () {
	echo "$1" 1>&2
	exit $2
}

if [ $( id -u ) -ne 0 ] ; then
        exit_error "Script must be run as root." 1
fi

spath="$( readlink -f "$0" )"
owndir="$( dirname "$spath" )"
cd "$owndir" || exit_error "$err_invdir" 1
test -f install.sh || exit_error "$err_invdir" 1
test -d zroot || exit_error "$err_invdir" 1

link_file () {
	src="$owndir/zroot/$1"
	tgt="/$1"
	tgt_parent="$( dirname "$tgt" )"

	mkdir -p "$tgt_parent" 2>/dev/null

	rm "$tgt" 2>/dev/null

	if [ $? -ne 0 ] ; then
		echo "Creating new link \`$tgt'."
	else
		echo "Replacing \`$tgt' with link."
	fi

	ln "$src" "$tgt"
}

link_file etc/skel/.bash_profile
link_file etc/skel/.bashrc
link_file etc/skel/.icons/mate/16x16/places/start-here.png
link_file etc/skel/.icons/mate/22x22/places/start-here.png
link_file etc/skel/.icons/mate/24x24/places/start-here.png
link_file etc/skel/.icons/mate/32x32/places/start-here.png
link_file etc/skel/.icons/mate/48x48/places/start-here.png
link_file etc/skel/.icons/mate/scalable/places/start-here-symbolic.svg
link_file etc/skel/.vimrc
link_file etc/skel/.xinitrc
link_file etc/skel/.Xdefaults

link_file usr/local/etc/poudriere.d/11amd64-local-python27-make.conf
link_file usr/local/etc/poudriere.d/11amd64-local-python27-pkglist
link_file usr/local/etc/poudriere.d/11amd64-local-python34-make.conf
link_file usr/local/etc/poudriere.d/11amd64-local-python34-pkglist
link_file usr/local/etc/poudriere.d/11amd64-local-python35-make.conf
link_file usr/local/etc/poudriere.d/11amd64-local-python35-pkglist

copy_file () {
	src="$owndir/zroot/$1"
	tgt="/$1"
	tgt_parent="$( dirname "$tgt" )"

	mkdir -p "$tgt_parent" 2>/dev/null

	rm "$tgt" 2>/dev/null

	if [ $? -ne 0 ] ; then
		echo "Creating new copy \`$tgt'."
	else
		echo "Replacing \`$tgt' with copy."
	fi

	cp "$src" "$tgt"
}

copy_file boot/loader.conf

copy_file etc/devd.conf
copy_file etc/devfs.rules
copy_file etc/login.conf
copy_file etc/pam.d/system
copy_file etc/rc.conf
copy_file etc/sysctl.conf
copy_file etc/wpa_supplicant.conf.sample

copy_file usr/local/etc/doas.conf
copy_file usr/local/etc/mail/mailer.conf
copy_file usr/local/etc/nginx/mime.types
copy_file usr/local/etc/nginx/nginx.conf
copy_file usr/local/etc/pkg/repos/custom-python27.conf
copy_file usr/local/etc/pkg/repos/custom-python34.conf
copy_file usr/local/etc/pkg/repos/custom-python35.conf
copy_file usr/local/etc/pkg/repos/FreeBSD.conf
copy_file usr/local/etc/pkg.conf
copy_file usr/local/etc/poudriere.conf
copy_file usr/local/etc/pulse/client.conf
copy_file usr/local/etc/pulse/daemon.conf
copy_file usr/local/etc/slim.conf
copy_file usr/local/etc/X11/xorg.conf.d/10-nvidia.conf
copy_file usr/local/etc/X11/xorg.conf.d/20-dvorak.conf
copy_file usr/local/share/applications/screensavers/freebsd-floaters.desktop
copy_file usr/local/share/pixmaps/bobble.png
copy_file usr/local/share/pixmaps/bobble.svg

link_dir () {
	src="$owndir/zroot/$1"
	tgt="/$1"
	tgt_parent="$( dirname "$tgt" )"

	mkdir -p "$tgt_parent" 2>/dev/null

	rm -rf "$tgt" 2>/dev/null

	if [ $? -ne 0 ] ; then
		echo "Creating new link \`$tgt'."
	else
		echo "Replacing \`$tgt' with link."
	fi

	ln -s "$src" "$tgt"
}

link_dir usr/local/etc/poudriere.d/11amd64-python35-options
link_dir usr/local/etc/poudriere.d/11amd64-python34-options
link_dir usr/local/etc/poudriere.d/11amd64-python27-options
