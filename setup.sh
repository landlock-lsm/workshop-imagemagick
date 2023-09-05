#!/usr/bin/env bash
# SPDX-License-Identifier: BSD-3-Clause
#
# Landlock workshop to sandbox ImageMagick
#
# This will automatically be executed by Vagrant while provisioning the VM.

set -ueo pipefail nounset errexit

if [[ -z "${VAGRANT_PROVISIONING:-}" ]]; then
	echo "This script should only be used by Vagrant provisioning." >&2
	exit 1
fi

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
	cp --no-preserve=mode -b /vagrant/home-config/bashrc .bashrc
	cp --no-preserve=mode -b /vagrant/home-config/vimrc .vimrc

	git config --global user.email "vagrant@workshop-imagemagick"
	git config --global user.name "Workshop"

	ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa -N ''

	asp update
	asp checkout imagemagick
	pushd imagemagick/trunk
		git checkout -b workshop d6d4293c0ec5250e4148c90592b83b0d48aa4a8e # v6.9.3.8-1
		cp --no-preserve=mode /vagrant/artifacts/ImageMagick-6.9.3-8.tar.xz .
		git am /vagrant/package-patches/*.patch
		makepkg -si --noconfirm
	popd
popd
-
