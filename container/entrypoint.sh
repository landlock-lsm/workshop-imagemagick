#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause
#
# Landlock workshop to sandbox ImageMagick
#
# Boot the backported kernel with virtme-ng.

set -euo pipefail

WORKSHOP="/home/workshop/workshop"

# Populate the bind-mounted workshop directory with the pre-built
# ImageMagick source on first run.
if [ ! -d "$WORKSHOP/src" ]; then
	cp -a /home/workshop/.cache/workshop-src "$WORKSHOP/src"
fi

KERNEL="$(ls /boot/vmlinuz-* | sort -V | tail -1)"

exec vng \
	--run "$KERNEL" \
	--qemu-opts="-no-reboot" \
	--append "panic=-1" \
	--append "audit=1" \
	--root / \
	--rw \
	--user workshop
