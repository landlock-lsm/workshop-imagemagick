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

See the [Linux Security Summit slides dedicated to this workshop](https://landlock.io/talks/2023-09-21_landlock-imagemagick-lss-eu.pdf).

## Install tools

For this workshop, we will use Vagrant to set up a dedicated virtual machine (VM).
Run the following commands as **root** according to your Linux distribution.

### Arch Linux

```bash
pacman -S vagrant libvirt base-devel dnsmasq
systemctl enable --now libvirtd.service
```

See the [Arch Linux libvirt tutorial](https://wiki.archlinux.org/title/libvirt) for more details.

### Debian or Ubuntu

```bash
apt install --no-install-recommends vagrant qemu-utils ruby-libvirt ruby-dev libvirt-daemon-system qemu-system
```

See the [Debian KVM tutorial](https://wiki.debian.org/KVM) for more details.

### Fedora

```bash
dnf install vagrant qemu libvirt
systemctl enable --now virtnetworkd
```

## Start the VM manager

Start libvirtd if needed:
```bash
systemctl start libvirtd.service
```

We then need to allow the developer (an unprivileged user) to use libvirt thanks to a dedicated group:
```bash
usermod -a -G libvirt <user>
```

This group update will take effect the next time the user logs in.
Alternatively, the user can update a shell session with:
```bash
su $USER
```

## Create and start the VM

As an **unprivileged user**, clone this repository:
```bash
git clone https://github.com/landlock-lsm/workshop-imagemagick
cd workshop-imagemagick
```

The Vagrant VM provisioning may install 2 vagrant plugins on the host system, other commands are executed in the VM.
After plugins installation (if any) Vagrant may ask to execute the same command again to proceed the VM configuration:
```bash
vagrant up
```

A virbr network interface will be created.
On most systems this should work as is, but otherwise we may need to allow inbound connections (and routing) from the loopback interface according to host's firewall rules.

## Create a snapshot of the VM

Just in case...
```bash
vagrant snapshot push
```

## Connect to the VM

```bash
vagrant ssh
```

## Test the VM

On the VM, run an ImageMagick command to test the attack:
```bash
convert /vagrant/exploit/malicious.mvg out.png
```

You should see the VM's SSH private key.

On the host system, check if you can copy files from the VM:
```bash
vagrant scp :out.png .
xdg-open out.png
```
