#!/bin/sh

# disable selinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# disable firewalld
systemctl disable firewalld.service --now

# configure hosts
cat <<EOF | tee /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
EOF

# configure resolv.conf
cat <<EOF | tee /etc/resolv.conf
nameserver 192.168.100.9
nameserver 168.126.63.1
EOF
