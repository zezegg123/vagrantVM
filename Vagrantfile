Vagrant.configure("2") do |config|
  (0..0).each do |i|
    config.vm.define "master-#{i}" do |node|
      node.vm.box = "bento/rockylinux-8.8"
      node.vm.hostname = "master-#{i}"
      node.vm.network "private_network", ip: "192.168.100.#{11 + i}"
        node.vm.provider "virtualbox" do |vb|
        vb.name = "master-#{i}"
        vb.memory = "2048"
        vb.cpus = 2
      end
      node.vm.provision "shell", path: "./script/install_k8s.sh"
    end
  end
  (0..0).each do |i|
    config.vm.define "worker-#{i}" do |node|
      node.vm.box = "bento/rockylinux-8.8"
      node.vm.hostname = "worker-#{i}"
      node.vm.network "private_network", ip: "192.168.100.#{14 + i}"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "worker-#{i}"
        vb.memory = "2048"
        vb.cpus = 2
      end
    end
  end
end