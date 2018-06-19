#!/bin/bash

echo "got $1 as master ip, $2 as id and $3 as roles"

#
# Don't care if these fail, it may be because firewalld isn't running to start with
sudo systemctl disable firewalld
sudo systemctl stop firewalld

set -ex
sudo yum install epel-release -y
#sudo yum -y update
sudo yum install wget yum-plugin-priorities -y
sudo yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
sudo yum clean expire-cache
sudo yum install salt-minion -y
sudo systemctl enable salt-minion
sudo service salt-minion stop
echo "master: $1" | sudo tee  -a /etc/salt/minion
echo "id: $2" | sudo tee -a /etc/salt/minion
echo "roles: [$3]" | sudo tee -a /etc/salt/grains
sudo hostnamectl set-hostname $2
sudo patch -p0 /etc/salt/minion /home/$USER/minion.patch
sudo service salt-minion start
