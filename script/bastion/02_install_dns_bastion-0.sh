#!/bin/sh

# install bind
#-------------------------
dnf install -y bind
#-------------------------

# create conf file
#---------------------------------------------------------------
cat <<EOF | tee /etc/named.conf
//
// named.conf
//
// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
// server as a caching only nameserver (as a localhost DNS resolver only).
//
// See /usr/share/doc/bind*/sample/ for example named configuration files.
//

options {
        listen-on port 53 { any; };
        listen-on-v6 port 53 { any; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { any; };

        /*
         - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
         - If you are building a RECURSIVE (caching) DNS server, you need to enable
           recursion.
         - If your recursive DNS server has a public IP address, you MUST enable access
           control to limit queries to your legitimate users. Failing to do so will
           cause your server to become part of large scale DNS amplification
           attacks. Implementing BCP38 within your network would greatly
           reduce such attack surface
        */
        recursion no;

        dnssec-validation yes;

        managed-keys-directory "/var/named/dynamic";
        geoip-directory "/usr/share/GeoIP";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";

        /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
        include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";

zone "jbyun.com" IN {
        type master;
        file "named.jbyun.com";
        allow-transfer { 192.168.100.11; };
        also-notify { 192.168.100.11; };
};
EOF
#---------------------------------------------------------------

# create zone file
#---------------------------------------------------------------
cat <<EOF | tee /var/named/named.jbyun.com
\$TTL 3H
@       IN SOA  ns1.jbyun.com. root.jbyun.com. (
                                        2025112301      ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
        NS      ns1.jbyun.com.
        NS      ns2.jbyun.com.
        ;A      192.168.100.10
        ;AAAA   ::1

ns1 IN A 192.168.100.10
ns2 IN A 192.168.100.11

bastion-0 IN A 192.168.100.10
bastion-1 IN A 192.168.100.11

master-0 IN A 192.168.100.12
master-1 IN A 192.168.100.13
master-2 IN A 192.168.100.14

worker-0 IN A 192.168.100.15
worker-1 IN A 192.168.100.16
worker-2 IN A 192.168.100.17
EOF
chown root:named /var/named/named.jbyun.com
#---------------------------------------------------------------

# start named
#---------------------------------------------------------------
systemctl enable named --now
#---------------------------------------------------------------
