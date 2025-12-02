#!/bin/sh

# install pkg
dnf -y install haproxy

# create conf file
APISERVER_DEST_PORT=6443
HOST1_ID=master-0
HOST1_ADDRESS=192.168.100.12
APISERVER_SRC_PORT=6443
HOST2_ID=master-1
HOST2_ADDRESS=192.168.100.13
HOST3_ID=master-2
HOST3_ADDRESS=192.168.100.14

cat <<EOF | tee /etc/haproxy/haproxy.cfg
# /etc/haproxy/haproxy.cfg
#---------------------------------------------------------------------
# Global settings
#---------------------------------------------------------------------
global
    log stdout format raw local0
    daemon

#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 1
    timeout http-request    10s
    timeout queue           20s
    timeout connect         5s
    timeout client          35s
    timeout server          35s
    timeout http-keep-alive 10s
    timeout check           10s

#---------------------------------------------------------------------
# apiserver frontend which proxys to the control plane nodes
#---------------------------------------------------------------------
frontend apiserver
    bind *:${APISERVER_DEST_PORT}
    mode tcp
    option tcplog
    default_backend apiserverbackend

#---------------------------------------------------------------------
# round robin balancing for apiserver
#---------------------------------------------------------------------
backend apiserverbackend
    option httpchk

    http-check connect ssl
    http-check send meth GET uri /healthz
    http-check expect status 200

    mode tcp
    balance     roundrobin

    server ${HOST1_ID} ${HOST1_ADDRESS}:${APISERVER_SRC_PORT} check verify none
    server ${HOST2_ID} ${HOST2_ADDRESS}:${APISERVER_SRC_PORT} check verify none
    server ${HOST3_ID} ${HOST3_ADDRESS}:${APISERVER_SRC_PORT} check verify none
EOF

# start service
systemctl enable haproxy --now
