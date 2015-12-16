# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/trusty64"
  config.vm.network :hostonly, "192.168.19.97"
  config.vm.host_name = "ckan.lo"
  config.vm.share_folder "./vagrant", "/vagrant", ".", :smb => true
  config.vm.provision :shell, :path => "vagrant/package_provision.sh"
  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/./vagrant", "1"]
  config.vm.customize ["modifyvm", :id, "--memory", 1024]
  config.vm.customize ["modifyvm", :id, "--cpus", 1]
  config.ssh.forward_agent = true
end
