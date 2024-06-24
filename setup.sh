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

apt purge --yes \
	wget

apt autoremove --yes
apt update
apt upgrade --yes

apt install --yes --no-install-recommends \
	cscope \
	gcc \
	git \
	htop \
	libpng-dev \
	make \
	pkg-config \
	silversearcher-ag \
	strace \
	tmux \
	tree \
	vim

cp --no-preserve=mode -b /vagrant/home-config/vimrc ~/.vimrc

sudo -u vagrant -s <<--
pushd /home/vagrant/
	cp --no-preserve=mode -b /vagrant/home-config/bashrc .bashrc
	cp --no-preserve=mode -b /vagrant/home-config/vimrc .vimrc

	git config --global user.email "vagrant@workshop-imagemagick"
	git config --global user.name "Workshop"

	ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa -N ''

	mkdir src
	tar -xf /vagrant/artifacts/ImageMagick-6.9.3-8.tar.xz -C src
	pushd src/ImageMagick-6.9.3-8
		/vagrant/imagemagick-patches/init-repo.sh
		git checkout -b solution
		git am /vagrant/imagemagick-patches/*.patch
		git checkout master
		./configure
		make -j$(nproc)
	popd
popd
-
