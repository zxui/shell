#!/usr/bin/env bash
wget http://mirrors.cnnic.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz

tar -zxvf ./apache-maven-3.3.9-bin.tar.gz

mv apache-maven-3.3.9 /opt/apache-maven-3.3.9

cat >/etc/profile.d/maven-3.3.9.sh<<EOF
export M2_HOME=/opt/apache-maven-3.3.9
         PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin
EOF

chown root.root /etc/profile.d/maven-3.3.9.sh