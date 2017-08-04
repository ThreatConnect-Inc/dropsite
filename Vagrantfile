# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.guest = :freebsd
  config.vm.synced_folder "dropsite", "/vagrant/dropsite", id: "dropsite-root", type: "rsync"
  config.vm.synced_folder "os", "/vagrant/os", id: "os-root", type: "rsync"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.ssh.shell = "sh"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.network :forwarded_port, guest: 80, host: 8081
  config.vm.box = "freebsd/FreeBSD-11.0-RELEASE-p1"
  config.vm.base_mac = ""
  config.vm.boot_timeout = 600

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--paravirtprovider", "default"]
    vb.customize ["modifyvm", :id, "--vram", "16"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--boot2", "none"]
  end

  config.push.define "ftp" do |push|
    push.host = ""
    push.username = "freebsd"
    push.secure = "true"
    push.destination = "/usr/local/www/dropsite"
    push.dir = "dropsite"
  end

end
