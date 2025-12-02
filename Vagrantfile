Vagrant.configure("2") do |config|
  (0..1).each do |i|
    config.vm.define "bastion-#{i}.jbyun.com" do |node|
      node.vm.box = "bento/rockylinux-9.6"
      node.vm.hostname = "bastion-#{i}.jbyun.com"
      node.vm.synced_folder "script/", "/script"
      node.vm.network "private_network", ip: "192.168.100.#{10 + i}"
        node.vm.provider "virtualbox" do |vb|
        vb.name = "bastion-#{i}.jbyun.com"
        vb.memory = "2048"
        vb.cpus = 2
      end
      node.vm.provision "shell", path: "script/bastion/01_configure_basic.sh"
      node.vm.provision "shell", path: "script/bastion/02_install_dns_bastion-#{i}.sh"
      node.vm.provision "shell", path: "script/bastion/03_install_keepalived_bastion-#{i}.sh"
      node.vm.provision "shell", path: "script/bastion/04_install_ha.sh"
    end
  end

  (0..2).each do |i|
    config.vm.define "master-#{i}.jbyun.com" do |node|
      node.vm.box = "bento/rockylinux-9.6"
      node.vm.hostname = "master-#{i}.jbyun.com"
      node.vm.synced_folder "script/", "/script"
      node.vm.network "private_network", ip: "192.168.100.#{12 + i}"
        node.vm.provider "virtualbox" do |vb|
        vb.name = "master-#{i}.jbyun.com"
        vb.memory = "2048"
        vb.cpus = 2
      end
      node.vm.provision "shell", path: "script/v1.34/01_configure_basic.sh"
      node.vm.provision "shell", path: "script/v1.34/02_install_kubeadm.sh"
      node.vm.provision "shell", path: "script/v1.34/03_create_cluster_master-#{i}.sh"
    end
  end
  (0..2).each do |i|
    config.vm.define "worker-#{i}.jbyun.com" do |node|
      node.vm.box = "bento/rockylinux-9.6"
      node.vm.hostname = "worker-#{i}.jbyun.com"
      node.vm.network "private_network", ip: "192.168.100.#{15 + i}"
      node.vm.synced_folder "script/", "/script"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "worker-#{i}.jbyun.com"
        vb.memory = "2048"
        vb.cpus = 2
      end
      node.vm.provision "shell", path: "script/v1.34/01_configure_basic.sh"
      node.vm.provision "shell", path: "script/v1.34/02_install_kubeadm.sh"
      node.vm.provision "shell", path: "script/v1.34/03_create_cluster_worker.sh"
    end
  end
end