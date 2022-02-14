#!/bin/bash

yum -y update
sudo yum install epel-release
sudo yum install epel-release

# Create a Separate User for Odoo
sudo useradd -m -U -r -d /opt/odoo -s /bin/bash odoo

# Install Python and Odoo Dependencies
sudo yum install -y python36 python36-devel

sudo yum install -y git gcc wget nodejs libxslt-devel bzip2-devel openldap-devel libjpeg-devel freetype-devel

# install postgreSQL
sudo yum install -y postgresql postgresql-server postgresql-contrib
sudo /usr/bin/postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
#Create a new PostgreSQL user
sudo su - postgres -c "createuser -s odoo"

sudo yum install -y wget nano
sudo wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox-0.12.6-1.centos7.x86_64.rpm
sudo yum localinstall -y wkhtmltox-0.12.6-1.centos7.x86_64.rpm

#download Odoo14
sudo su - odoo
git clone https://www.github.com/odoo/odoo --depth 1 --branch 14.0 /opt/odoo/odoo14
cd /opt/odoo && python3 -m venv odoo14-venv
source odoo14-venv/bin/activate
pip3 install -r odoo14/requirements.txt
sleep 1
deactivate && exit

#  Create Directories for Custom Addons and Odoo Logs

# Create custom addons folder:
sudo mkdir /opt/odoo/odoo14-custom-addons
# Make the ‘odoo’ user as the owner:
sudo chown odoo: /opt/odoo/odoo14-custom-addons
# Create a directory to store odoo logs:
sudo mkdir /var/log/odoo14
# Create an empty log file:
sudo touch /var/log/odoo14/odoo.log
# Make the ‘odoo’ user the owner of it as well: 
sudo chown -R odoo: /var/log/odoo14/


