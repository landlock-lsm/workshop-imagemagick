# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # Force the use of libvirt as a VM provider.
  config.vm.provider "libvirt"
  # Archlinux image and version
  config.vm.box = "archlinux/archlinux"
  config.vm.box_version = "20230104.116125"
  config.vagrant.plugins = ["vagrant-libvirt", "vagrant-scp", "vagrant-reload"]

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Synchronize provision scripts and data into /vagrant
  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  # Execute VM provisionning and reboot in order to use the new kernel.
  config.vm.provision "shell", path: "setup.sh"
  config.vm.provision :reload
end
