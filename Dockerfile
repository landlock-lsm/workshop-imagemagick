# SPDX-License-Identifier: BSD-3-Clause
#
# Landlock workshop to sandbox ImageMagick
#
# Container image with a backported kernel (6.18 for Landlock audit
# support), virtme-ng, and a pre-built vulnerable ImageMagick.

FROM debian:trixie

RUN echo "deb http://deb.debian.org/debian trixie-backports main" \
    > /etc/apt/sources.list.d/backports.list

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      busybox-static \
      cscope \
      gcc \
      git \
      htop \
      libpng-dev \
      linux-image-amd64/trixie-backports \
      linux-libc-dev/trixie-backports \
      make \
      manpages-dev \
      openssh-client \
      pkg-config \
      procps \
      qemu-system-x86 \
      silversearcher-ag \
      strace \
      sudo \
      tmux \
      tree \
      vim \
      virtiofsd \
      virtme-ng \
      xz-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash workshop

COPY artifacts/ /tmp/workshop/artifacts/
COPY imagemagick-patches/ /tmp/workshop/imagemagick-patches/
COPY home-config/ /tmp/workshop/home-config/
RUN chmod -R a+rX /tmp/workshop

USER workshop
WORKDIR /home/workshop

RUN cp /tmp/workshop/home-config/vimrc ~/.vimrc && \
    cat /tmp/workshop/home-config/bashrc >> ~/.bashrc

RUN ssh-keygen -t ecdsa -f ~/.ssh/id_ecdsa -N ''

RUN git config --global user.email "workshop@imagemagick" && \
    git config --global user.name "Workshop"

RUN mkdir -p ~/workshop/src && \
    tar -xf /tmp/workshop/artifacts/ImageMagick-6.9.3-8.tar.xz -C ~/workshop/src && \
    cd ~/workshop/src/ImageMagick-6.9.3-8 && \
    /tmp/workshop/imagemagick-patches/init-repo.sh && \
    git checkout -b solution && \
    git am /tmp/workshop/imagemagick-patches/*.patch && \
    git checkout master && \
    ./configure && make -j$(nproc) && \
    mkdir -p ~/.cache && mv ~/workshop/src ~/.cache/workshop-src

USER root
RUN find /tmp -mindepth 1 -delete

COPY container/entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
