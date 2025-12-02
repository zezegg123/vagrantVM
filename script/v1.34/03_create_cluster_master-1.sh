#!/bin/sh

# join cluster
eval "$(grep -m1 -A2 '192.168.100.9:6443' /vagrant/script/v1.34/init.log | tr -d '\\' | tr '\n' ' ' | xargs) --apiserver-advertise-address 192.168.100.13"

mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown $(id -u):$(id -g) /root/.kube/config

