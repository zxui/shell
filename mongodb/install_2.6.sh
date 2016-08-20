#!/usr/bin/env bash
cp  ../base/repo/10gen.repo /etc/yum.repos.d/

yum -y install mongo-10gen-server.x86_64 mongo-10gen.x86_64