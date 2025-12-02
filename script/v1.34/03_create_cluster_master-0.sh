#!/usr/bin/bash

# install cluster
kubeadm init --pod-network-cidr 172.16.0.0/16 --apiserver-advertise-address 192.168.100.12 --control-plane-endpoint 192.168.100.9 --upload-certs > /vagrant/script/v1.34/init.log 2>&1

mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown $(id -u):$(id -g) /root/.kube/config

# install Tigera Operator
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.2/manifests/operator-crds.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.2/manifests/tigera-operator.yaml

# install custom resources
curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.31.2/manifests/custom-resources.yaml
sed -i 's/192.168.0.0/172.16.0.0/' custom-resources.yaml
kubectl create -f custom-resources.yaml
