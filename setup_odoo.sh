#!/bin/bash

#cai cac goi can thiet

sudo yum install -y gcc git wget libxslt-devel bzip2-devel openldap-devel libjpeg-devel freetype-devel unzip
sudo yum install -y python3-devel readline-devel openssl-devel libffi-devel make sqlite-devel

#tao tep de luu source code
cd /tmp
git clone 
mkdir -p /opt/tsm-backend
chown tsm.tsm /opt/tsm-backend
unzip odoo12.zip -d /opt/tsm-backend/

#sang user tsm
su - tsm
cd /tmp
curl https://pyenv.run | bash
cd
echo 'export PATH="/$HOME/.pyenv/bin:$PATH"' >> .bashrc
echo 'eval "$(pyenv init -)"' >> .bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> .bashrc

echo 'export PATH="/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/$HOME/.pyenv/bin"' >> .bash_profile
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> .bash_profile
echo 'export PATH="$PYENV_ROOT/shims:$PATH"' >> .bash_profile

exec $SHELL -l
source /$HOME/.bash_profile

pyenv install 3.6.9
cd /opt/tsm-backend
pyenv virtualenv 3.6.9 tsm-backend-env
pyenv local tsm-backend-env
pip install --upgrade pip
pip install -r odoo12/requirements.txt
exit

# install wkhtmltopdf
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.1/wkhtmltox-0.12.1_linux-centos7-amd64.rpm

yum localinstall -y wkhtmltox-0.12.1_linux-centos7-amd64.rpm

# install PostgreSQL 13
sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum -y install postgresql13 postgresql13-server
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
sudo systemctl start postgresql-13

# Create user for odoo
su - postgres
psql
create user tsm with encrypted password 'tsm123';
alter user tsm createdb;
\q
exit

# create file config odoo
mv tsm-backend.conf /etc/
mv backend.service /etc/systemd/system/

# create file log
mkdir /var/log/backend
touch /var/log/backend/tsm-backend.log
sudo chown -R tsm: /var/log/backend/

systemctl daemon-reload
systemctl start backend
systemctl enable backend

# install nginx
sudo yum install -y epel-release
sudo yum install -y nginx

systemctl start nginx
systemctl enable nginx
# reverse proxy
mv tsm_od.conf /etc/nginx/conf.d/
systemctl restart nginx

firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload





