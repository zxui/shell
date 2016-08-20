#!/usr/bin/env bash
yum -y install mysql-server
chkconfig mysqld on

cat > /etc/my.conf<<EOF
[mysqld]
port = 3306
default-character-set=utf8
init_connect='SET NAMES  utf8'
lower_case_table_names=1
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF

service mysqld start