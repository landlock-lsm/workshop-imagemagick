#!/usr/bin/env bash
# SPDX-License-Identifier: BSD-3-Clause
#
# Landlock workshop to sandbox ImageMagick

set -ueo pipefail nounset errexit

cd "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

set -x

pacman -Sy --noconfirm
pacman -S --noconfirm \
	asp \
	base-devel \
	bash-completion \
	cscope \
	git \
	openbsd-netcat \
	pacman-contrib \
	strace \
	tmux \
	tree \
	vim

systemctl disable --now systemd-time-wait-sync.service

cp --no-preserve=mode -b /vagrant/home-config/vimrc ~/.vimrc

sudo -u vagrant -s <<--
pushd /home/vagrant/
	cp --no-preserve=mode -b /vagrant/home-config/vimrc .vimrc

	asp update
	asp checkout imagemagick
	pushd imagemagick/trunk
		git checkout -b workshop d6d4293c0ec5250e4148c90592b83b0d48aa4a8e # v6.9.3.8-1
	popd
popd
-
