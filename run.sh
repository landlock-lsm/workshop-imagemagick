#!/usr/bin/env bash
# SPDX-License-Identifier: BSD-3-Clause
#
# Landlock workshop to sandbox ImageMagick
#
# Build the container image and start the VM.

set -euo pipefail

cd "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

if [ ! -e /dev/kvm ]; then
	echo "Error: /dev/kvm not found. Is KVM supported on this host?" >&2
	exit 1
fi

if [ ! -r /dev/kvm ] || [ ! -w /dev/kvm ]; then
	echo "Error: /dev/kvm is not accessible. Try: sudo usermod -aG kvm \$USER && newgrp kvm" >&2
	exit 1
fi

IMAGE_NAME="workshop-imagemagick"

docker build -t "$IMAGE_NAME" .
docker run --device /dev/kvm -v "$(pwd)":/home/workshop/workshop -it "$IMAGE_NAME"
