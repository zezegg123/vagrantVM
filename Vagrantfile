Vagrant.configure("2") do |config|
  #config.vm.define "example", primary: true do |machine|
  #config.vm.define "example", autostart: false do |machine|
  #config.vm.define "example" do |machine|

    #machine.vm.box = "ubuntu/trusty64"
    #machine.vm.box_version = "20191107.0.0"

    #machine.vm.hostname = "example"
    #machine.vm.disk :dvd, name: "rhel-8.8-x86_64-dvd", file: "./rhel-8.8-x86_64-dvd.iso"
    #machine.vm.synced_folder "./terramino-go", "/home/vagrant/terramino-go", create: true 

    #machine.vm.network "private_network", ip: 192.168.123.10
    #machine.vm.network "forwarded_port", guest: 6379, host: 6379
    #machine.vm.network "forwarded_port", guest: 8080, host: 8080
    
    #machine.vm.provision "shell", name: "install-dependencies", path: "install-dependencies.sh"
    #machine.vm.provision "shell", name: "just-run", inline: <<-SHELL
      #echo "just-run" > yoon.txt
    #SHELL
    #machine.vm.provision "shell", name: "run-never", run: "never", inline: <<-SHELL
      #echo "run-never" > yoon.txt
    #SHELL
  #end
  config.vm.define "example", autostart: false do |machine|
    machine.vm.box = "bento/almalinux-8.8"
    machine.vm.hostname = "example"
  end
end