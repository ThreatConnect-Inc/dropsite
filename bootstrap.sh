#!/bin/sh

# Configure PF firewall
cp /vagrant/os/config/pf.conf /etc/pf.conf
sysrc -q pf_enable=YES > /dev/null
sysrc -q pflog_enable=YES > /dev/null

# Install root CA certificates
pkg install -q --yes ca_root_nss > /dev/null

# Set the clock
sysrc -q ntpd_enable=YES > /dev/null
service ntpd start > /dev/null

# Make UTF-8 the default
patch -s --posix /etc/login.conf /vagrant/os/patch/login_conf.patch
cap_mkdb /etc/login.conf

# Install complete make.conf
cp /vagrant/os/config/make.conf /etc/make.conf

# Install tmux
pkg install -q --yes tmux > /dev/null

# Install portmaster
pkg install --yes /vagrant/os/packages/portmaster-3.17.10.txz > /dev/null

# Install OpenSSH
pkg install --yes /vagrant/os/packages/openssh-portable-7.5.p1,1.txz > /dev/null
patch -s --posix /usr/local/etc/ssh/sshd_config /vagrant/os/patch/sshd_config.patch
#service sshd stop > /dev/null
sysrc -q sshd_enable=NO > /dev/null
sysrc -q openssh_enable=YES > /dev/null
#service openssh start > /dev/null

# Install NGINX Mainline
pkg install -q --yes nginx-devel > /dev/null
patch -s --posix /usr/local/etc/nginx/nginx.conf /vagrant/os/patch/nginx_conf.patch
sysrc -q nginx_enable=YES > /dev/null
echo -n 'test:' > /usr/local/etc/nginx/.htpasswd
openssl passwd -crypt testtest >> /usr/local/etc/nginx/.htpasswd
service nginx start > /dev/null

# Install Python3
pkg install -q --yes python36 > /dev/null
fetch -q -o /root https://bootstrap.pypa.io/get-pip.py
python3.6 /root/get-pip.py > /dev/null
rm /root/get-pip.py

# Install Flask
pip3 install Flask > /dev/null
pip3 install flask-bootstrap > /dev/null

# Install requests
pip3 install requests > /dev/null

# Install uWSGI
pkg install --yes /vagrant/os/packages/py36-setuptools-32.1.0_1.txz > /dev/null
pkg install --yes /vagrant/os/packages/uwsgi-2.0.14_2.txz > /dev/null

# Cleanup OS configuration
sysrc -q -a -e /etc/rc.conf > /root/rc.conf && mv /root/rc.conf /etc/rc.conf

# Create socket directory for uWSGI
mkdir /var/run/uwsgi
chown www:www /var/run/uwsgi

# Create directory for uploaded files
mkdir /uploads
chown www:www /uploads
/vagrant/dropsite/reset.py
chown www:www /uploads/last_run.json

# Install uWSGI startup file
cp /vagrant/os/config/rc.local /etc/rc.local

# Launch uWSGI Emperor
/usr/local/bin/uwsgi --emperor /vagrant/dropsite --uid www --gid www --daemonize /var/log/uwsgi-emperor.log

# Adjust crontab to run webhook
patch -s --posix /etc/crontab /vagrant/os/patch/crontab.patch
