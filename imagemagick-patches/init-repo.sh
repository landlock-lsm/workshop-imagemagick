#!/usr/bin/env bash
# SPDX-License-Identifier: BSD-3-Clause
#
# Landlock workshop to sandbox ImageMagick
#
# Prepare ImageMagick repository

set -ueo pipefail nounset errexit

PATCH_DIR="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

set -x

git init
cp "${PATCH_DIR}/gitignore" .gitignore
git add -A
git commit -m "Initial import"
