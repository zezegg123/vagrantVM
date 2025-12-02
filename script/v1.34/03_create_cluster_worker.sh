#!/bin/sh

# join cluster
eval "$(grep -A1 '^kubeadm' /vagrant/script/v1.34/init.log | tr -d '\\' | tr '\n' ' ' | xargs)"
