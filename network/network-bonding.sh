#!/usr/bin/env bash
service NetworkManager stop
chkconfig NetworkManager off
touch /etc/sysconfig/network-scripts/ifcfg-bond0
chmod 777 /etc/sysconfig/network-scripts/ifcfg-bond0
cat>>/etc/sysconfig/network-scripts/ifcfg-bond0<<EOF
DEVICE=bond0
IPADDR=172.16.3.101
PREFIX=24
ONBOOT=yes
BOOTPROTO=none
USERCTL=no
BONDING_OPTS="mode=0 miimon=5"
EOF
cat<<EOF>>/etc/sysconfig/network-scripts/ifcfg-eth0
MASTER=bond0
SLAVE=yes
EOF
cat<<EOF>>/etc/sysconfig/network-scripts/ifcfg-eth1
MASTER=bond0
SLAVE=yes
EOF
cat<<EOF>>/etc/sysconfig/network-scripts/ifcfg-eth2
MASTER=bond0
SLAVE=yes
EOF
touch /etc/modprobe.d/bonding.conf
chmod 777 /etc/modprobe.d/bonding.conf
cat>>/etc/modprobe.d/bonding.conf<<EOF
alias bond0 bonding
EOF
cat<<EOF>>/etc/rc.local
ifenslave bond0 eth0 eth1 eth2
EOF
ifup bond0
