# Landlock tutorial to patch lighttpd

Network access-control is well covered by different kind of firewalls, but for some use cases it may be interesting to tie the semantic of an application instance and its configuration to a set of rules.
For instance, only some processes of web browsers or web servers may legitimately be allowed to share data over the network, while other processes should be blocked.
Linux provides some mechanisms to do so, including SELinux or AppArmor, but until now it has not been possible for applications to safely sandbox themselves.

Slides: [How to sandbox an application with Landlock](How%20to%20sandbox%20an%20application%20with%20Landlock.pdf)

## Install tools

For this tutorial, we will use Vagrant to set up a dedicated virtual machine (VM).
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
git clone https://github.com/landlock-lsm/tuto-lighttpd
cd tuto-lighttpd
```

The Vagrant VM provisioning will install 3 vagrant plugins on the host system, other commands are executed in the VM.
After plugins installation Vagrant will ask to execute the same command again to proceed the VM configuration:
```bash
vagrant up
```

A virbr network interface will be created.
On most systems this should work as is, but otherwise we may need to allow inbound connections (and routing) from the loopback interface according to host's firewall rules.

## Connect to the VM

```bash
vagrant ssh
```

## Test the VM

On the VM, start the lighttpd service and check the logs:
```bash
sudo systemctl start lighttpd.service
sudo journalctl -fu lighttpd.service &
sudo tail -F /var/log/lighttpd/error.log &
```

Use the `getlink.sh` script to get the local website link:
```bash
/vagrant/getlink.sh
```

Visit the link with a web browser to validate that it works.
This link may change each time the VM starts.
