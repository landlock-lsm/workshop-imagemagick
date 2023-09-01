#!/usr/bin/env bash
#
# Landlock tutorial to patch lighttpd

set -ueo pipefail nounset errexit

cd "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

set -x

pacman -Sy --noconfirm
pacman -S --noconfirm base-devel asp bash-completion vim tmux tree git openbsd-netcat strace cscope lighttpd fcgi php-cgi pacman-contrib liburing lua mariadb-libs

pushd /vagrant/
	cp --no-preserve=mode -b vmlinuz-landlock-net /boot/vmlinuz-linux
	cp --no-preserve=mode -b config/lighttpd.conf /etc/lighttpd/lighttpd.conf
	cp --no-preserve=mode -b config/php.ini /etc/php/php.ini
	cp --no-preserve=mode -b landlock.h /usr/include/linux/landlock.h
	cp --no-preserve=mode web/*.php /srv/http/
	cp --no-preserve=mode vimrc ~/.vimrc
popd

sudo -u vagrant -s <<--
pushd /home/vagrant/
	asp update
	asp checkout lighttpd
	pushd lighttpd/trunk
		gpg --import keys/pgp/*.asc
		makepkg -si --noconfirm
	popd
popd
-

systemctl enable --now lighttpd.service
systemctl disable --now systemd-time-wait-sync.service
