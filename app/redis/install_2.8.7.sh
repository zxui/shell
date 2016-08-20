#!/usr/bin/env bash
yum -y install gcc-c++
yum -y install tcl
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
mv redis-stable /opt/redis-stable
cd /opt/redis-stable
make distclean
make
cp redis-server /usr/local/bin/
cp redis-cli /usr/local/bin/
mkdir /etc/redis
mkdir /var/redis
mkdir /var/redis/log
mkdir /var/redis/run
mkdir /var/redis/6379
cp redis.conf /etc/redis/6379.conf

cat>/etc/redis/6379.conf<<EOF
daemonize yes
pidfile /var/redis/run/redis_6379.pid
logfile /var/redis/log/redis_6379.log
dir /var/redis/6379
EOF

redis-server /etc/redis/6379.conf
