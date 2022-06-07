# -*- mode: ruby -*-

Vagrant.configure("2") do |config|

  config.vm.define "dirsrv" do |box|
    box.vm.box = "generic/rocky8"
    box.vm.box_version = "3.6.14"
    box.vm.hostname = 'dirsrv.vagrant.example.lan'
    box.vm.provider 'virtualbox' do |vb|
      vb.gui = false
      vb.memory = 1280
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--hpet", "on"]
    end
    box.vbguest.installer_options = { allow_kernel_upgrade: true }
    box.vm.network "private_network", ip: "192.168.59.217"
    box.vm.synced_folder ".", "/vagrant"
    box.vm.provision "shell", path: "vagrant/common.sh"
    box.vm.provision "shell",
      inline: "/opt/puppetlabs/bin/puppet apply /vagrant/vagrant/hosts.pp --modulepath=/vagrant/modules",
      env: {  'FACTER_my_host': 'dirsrv.vagrant.example.lan',
              'FACTER_my_ip': '192.168.59.175' }
    box.vm.provision "shell",
      inline: "/opt/puppetlabs/bin/puppet apply /vagrant/vagrant/dirsrv.pp --modulepath=/vagrant/modules"
  end
end
