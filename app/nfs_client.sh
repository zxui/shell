
#!/usr/bin/env bash
mkdir  /newusr
chmod  777  /newusr
mount 172.16.16.1:/usr /newusr
cat>>/etc/fstab<<EOF
mount 172.16.16.1:/usr /newusr nfs defaults,soft,intr 0 0
EOF