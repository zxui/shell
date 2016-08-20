#!/usr/bin/env bash
yum -y install memcached

chkconfig memcached on

memcached -h