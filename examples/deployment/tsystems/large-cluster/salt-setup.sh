#!/bin/bash

echo "got $1 as master ip, $2 as id and $3 as roles"

#
# Don't care if these fail, it may be because firewalld isn't running to start with
sudo systemctl disable firewalld
sudo systemctl stop firewalld

set -x
echo "master: $1" | sudo tee  -a /etc/salt/minion
echo "id: $2" | sudo tee -a /etc/salt/minion
echo "roles: [$3]" | sudo tee /etc/salt/grains # not 'tee -a', force overwrite...
sudo hostnamectl set-hostname $2

sudo systemctl enable salt-minion
sudo service salt-minion start

sudo yum install salt-master -y
sudo mv /home/${var.user}/master /etc/salt/master
sudo hostname salt-master
sudo service salt-master restart

# sudo salt salt-master state.apply consul.init
# sudo salt '*' state.highstate
