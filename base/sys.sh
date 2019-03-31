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
#CTCDN系统优化参数
#关闭ipv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
# 避免放大攻击
net.ipv4.icmp_echo_ignore_broadcasts = 1
# 开启恶意icmp错误消息保护
net.ipv4.icmp_ignore_bogus_error_responses = 1
#关闭路由转发
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
#开启反向路径过滤
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
#处理无源路由的包
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
#关闭sysrq功能
kernel.sysrq = 0
#core文件名中添加pid作为扩展名
kernel.core_uses_pid = 1
# 开启SYN洪水攻击保护
net.ipv4.tcp_syncookies = 1
#修改消息队列长度
kernel.msgmnb = 65536
kernel.msgmax = 65536
#设置最大内存共享段大小bytes
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
#timewait的数量，默认180000
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096        87380   4194304
net.ipv4.tcp_wmem = 4096        16384   4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
#每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目
net.core.netdev_max_backlog = 262144
#限制仅仅是为了防止简单的DoS 攻击
net.ipv4.tcp_max_orphans = 3276800
#未收到客户端确认信息的连接请求的最大值
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
#内核放弃建立连接之前发送SYNACK 包的数量
net.ipv4.tcp_synack_retries = 1
#内核放弃建立连接之前发送SYN 包的数量
net.ipv4.tcp_syn_retries = 1
#启用timewait 快速回收
net.ipv4.tcp_tw_recycle = 1
#开启重用。允许将TIME-WAIT sockets 重新用于新的TCP 连接
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
#当keepalive 起用的时候，TCP 发送keepalive 消息的频度。缺省是2 小时
net.ipv4.tcp_keepalive_time = 30
#允许系统打开的端口范围
net.ipv4.ip_local_port_range = 1024    65000
#修改防火墙表大小，默认65536
#net.netfilter.nf_conntrack_max=655350
#net.netfilter.nf_conntrack_tcp_timeout_established=1200
# 确保无人能修改路由表
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
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
