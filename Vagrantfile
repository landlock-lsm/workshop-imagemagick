# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.hostname = "workshop-imagemagick"

  # Force the use of libvirt as a VM provider.
  config.vm.provider "libvirt" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  # Archlinux image and version
  config.vm.box = "debian/bookworm64"
  config.vagrant.plugins = ["vagrant-libvirt", "vagrant-scp"]

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Synchronize provision scripts and data into /vagrant
  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  # Execute VM provisioning.
  config.vm.provision "shell", path: "setup.sh", env: {"VAGRANT_PROVISIONING" => "1"}
end
