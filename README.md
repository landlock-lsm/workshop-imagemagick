# Landlock workshop to sandbox ImageMagick

The goal of this workshop is to illustrate how sandboxing can mitigate vulnerabilities.
To showcase usefulness of sandboxing, we'll use an old and vulnerable version of [ImageMagick](https://imagemagick.org/)
which has long been fixed, but all kind of applications could still be impacted by [similar vulnerabilities](https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=RCE).

The [CVE-2016-3714](https://nvd.nist.gov/vuln/detail/CVE-2016-3714) vulnerability,
aka [ImageTragick](https://imagetragick.com/),
is caused by an insufficient shell characters filtering that can lead to (potentially remote) code execution.
Thanks to [Landlock](https://landlock.io/),
we'll restrict the `convert` tool's access rights before it can get exploited by opening a malicious file,
and then mitigate the impact of such vulnerability.

See the slides dedicated to this [Landlock workshop](https://landlock.io/talks/2024-07-03_landlock-pts-workshop.pdf).

## Requirements

- [Docker](https://docs.docker.com/engine/install/)
- `/dev/kvm` accessible (KVM support is required for virtme-ng to boot the kernel efficiently).
  Your user must be in the `kvm` group:
  ```bash
  sudo usermod -aG kvm $USER
  newgrp kvm
  ```

## Build and start the VM

Clone this repository:
```bash
git clone https://github.com/landlock-lsm/workshop-imagemagick
cd workshop-imagemagick
```

Build the container image and start the VM:
```bash
./run.sh
```

The first run can take a few minutes because it downloads the base container image (~50 MB)
and packages (~320 MB), and compiles ImageMagick from source.
It is OK to see a lot of build warnings because the ImageMagick source code is old compared to the build tools.
Subsequent runs will start the VM almost instantly since the image is cached.

The container boots a Debian Trixie backported kernel (6.18) using virtme-ng,
which provides full Landlock support including audit.
The workshop repository is bind-mounted into the VM for live file synchronization.

## Test the VM

In the VM, run an ImageMagick command to test the attack:
```bash
convert ~/workshop/exploit/malicious.mvg out.png
```

You should see the VM's SSH private key.

Check the generated image:
```bash
xdg-open out.png
```

You should see a white square.
