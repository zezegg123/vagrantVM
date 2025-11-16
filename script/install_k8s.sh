#!/usr/bin/bash
# port open for master
systemctl enable firewalld --now
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10259/tcp
firewall-cmd --permanent --add-port=10257/tcp
firewall-cmd --reload

# swap off
swapoff -a
sed -i -E 's/^([[:space:]]*[^#][^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+swap([[:space:]]|$))/# \1/' /etc/fstab

# ipv4 forwarding
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe br_netfilter
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# containerd install
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

# systemd cgroup settig
cat <<EOF | tee /etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = true
EOF
systemctl restart containerd

# install kubectl
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
dnf install -y bash-completion
grep -qxF "source <(kubectl completion bash)" /etc/bashrc || echo "source <(kubectl completion bash)" >> /etc/bashrc
grep -qxF "alias k=kubectl" /etc/bashrc || echo "alias k=kubectl" >> /etc/bashrc
grep -qxF "complete -o default -F __start_kubectl k" /etc/bashrc || echo "complete -o default -F __start_kubectl k" >> /etc/bashrc

systemctl enable --now kubelet
