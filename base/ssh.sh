#!/bin/bash
#author sean

#create user
echo 'Create new user ...'
for name in admin
do
 useradd $name
 echo "admin" | passwd --stdin $name
 history –c
done

#set ssh cert
echo 'Configure SSH...'
mkdir -p /home/admin/.ssh
cp keys/authorized_keys /home/admin/.ssh/
cp keys/client_rsa /home/admin/.ssh/
chmod 600 /home/admin/.ssh/client_rsa
chown -R admin.admin /home/admin/.ssh

#set ssh
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
sed -i 's/#StrictModes yes/StrictModes no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/#PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 9022/' /etc/ssh/sshd_config
cat>>/etc/ssh/ssh_config<<EOF
IdentityFile ~/.ssh/client_rsa
EOF

