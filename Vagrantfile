# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.box = "scotch/box"
    config.vm.network "private_network", ip: "192.168.33.66"
    config.vm.hostname = "scotchbox"

	#config.ssh.forward_agent = true
    config.vm.synced_folder "sulu", "/shared/sulu", :nfs => { :mount_options => ["dmode=777","fmode=666"] }
    config.vm.synced_folder "vagrant", "/shared/vagrant", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

	config.vm.provider :virtualbox do |vb|
		vb.customize ["modifyvm", :id, "--memory", "2048"]
		vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
		vb.name = "sulu-devbox"
	end

	config.vm.provision "shell", path: "vagrant/provision.sh", privileged: false

end