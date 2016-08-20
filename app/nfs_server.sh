#!/usr/bin/env bash
service   nfs  start
service    rpcbind    start    
chkconfig     rpcbind     on   
chkconfig    nfs    on   
cp /etc/exports /etc/exports.bak
cat>>/etc/exports<<EOF
/newusr 192.168.134.0/24(rw,sync,no_root_squash)
EOF
service    nfs     restart   
service    rpcbind   restart  
mkdir  /newusr
chmod  o+w    /newusr
