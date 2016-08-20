#!/bin/bash 
#author sean

#set the file limit
cat >> /etc/security/limits.conf <<EOF
 *  -  nofile  65535
 *  -  nproc   65535
EOF

#set system language utf8
cat>/etc/sysconfig/i18n<<EOF
LANG="zh_CN.UTF-8"
EOF

#set DNS
cat>>/etc/resolv.conf<<EOF
nameserver 202.101.172.35
nameserver 202.101.172.47
EOF

#set hosts
cat>>/etc/hosts<<EOF
172.16.3.101 nginx1
EOF

#set the control-alt-delete to guard against the miSUSE 
sed -i 's#exec /sbin/shutdown -r now#\#exec /sbin/shutdown -r now#' /etc/init/control-alt-delete.conf 

#disable selinux 
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config 

#Full multiuser mode
sed -i 's/id:5:initdefault:/id:3:initdefault:/' /etc/inittab
 
#tune kernel parametres
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_max_syn_backlog = 16384
net.core.netdev_max_backlog =  16384
net.core.somaxconn = 32768
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_timestamps = 0
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.ip_local_port_range = 2000  65535
net.ipv4.tcp_max_tw_buckets = 5000
vm.swappiness=10
EOF

#stop some crontab 
mkdir /etc/cron.daily.bak 
mv /etc/cron.daily/makewhatis.cron /etc/cron.daily.bak 
mv /etc/cron.daily/mlocate.cron /etc/cron.daily.bak 
chkconfig bluetooth off 
chkconfig cups off 
chkconfig ip6tables off 
chkconfig --level 35 iptables off
for sun in `chkconfig --list|grep 3:on|awk '{print $1}'`;do chkconfig --level 3 $sun off;done
for sun in crond rsyslog sshd network;do chkconfig --level 3 $sun on;done

#disable the ipv6 
cat > /etc/modprobe.d/ipv6.conf << EOF
alias net-pf-10 off 
options ipv6 disable=1 
EOF
echo "NETWORKING_IPV6=off" >> /etc/sysconfig/network 

#add yum
cp  repo/10gen.repo /etc/yum.repos.d/
cp  repo/mongodb-org-3.0.repo /etc/yum.repos.d/
cp  repo/nginx.repo /etc/yum.repos.d/
#make the 163.com as the default yum repo 
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup 
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -O /etc/yum.repos.d/CentOS-Base.repo 
#add the third-party repo 
#add the epel 
rpm -Uvh http://download.Fedora.RedHat.com/pub/epel/6/x86_64/epel-release-6-5.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 
#add the rpmforge 
rpm -Uvh http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag 
#update the system and set the ntp 
yum -y install ntp 
echo "* 4 * * * /usr/sbin/ntpdate s2m.time.edu.cn > /dev/null 2>&1" >> /var/spool/cron/root
 
cat << EOF 
+-------------------------------------------------+
| optimizer is done | 
| its recommond to restart this server ! | 
+-------------------------------------------------+ 
EOF
