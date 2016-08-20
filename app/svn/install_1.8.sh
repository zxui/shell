#!/usr/bin/env bash
cat>/etc/yum.repos.d/wandisco-svn.repo<<EOF
[WandiscoSVN]
name=Wandisco SVN Repo
baseurl=http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/$basearch/
enabled=1
gpgcheck=0
EOF

echo '[1]create WandiscoSVN.epo success!'
yum -y install mod_dav_svn subversion
echo '[2]install subversion success!'
cat>/etc/httpd/conf.d/subversion.conf<<EOF
# Make sure you uncomment the following if they are commented out
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so

# Add the following to allow a basic authentication and point Apache to where the actual
# repository resides.
<Location /repos>
        DAV svn
        SVNPath /var/www/svn/repos
        AuthzSVNAccessFile /etc/svn-acl-conf
        AuthType Basic
        AuthName "Subversion repos"
        AuthUserFile /etc/svn-auth-conf
        Require valid-user
</Location>
EOF
echo '[3]svn setting success!'
cat>/etc/svn-acl-conf<<EOF
[groups]
staff = admin
[framework:/]
@staff = rw
EOF
echo '[4]svn authority setting success!'
mkdir -p /var/www/svn
svnadmin create /var/www/svn/repos
chown -R admin.admin /var/www/svn/repos
chmod -R o+x /var/www/svn/repos
#service httpd start