#!/bin/bash

echo "got $1 as master ip, $2 as id and $3 as roles"

#
# Don't care if these fail, it may be because firewalld isn't running to start with
sudo systemctl disable firewalld
sudo systemctl stop firewalld

set -x
cat /etc/salt/minion | egrep -v '^master: |^id: ' | tee /tmp/minion.orig >/dev/null
(
  cat /tmp/minion.orig
  echo "master: $1"
  echo "id: $2"
) | sudo tee /etc/salt/minion
echo "roles: [$3]" | sudo tee /etc/salt/grains
sudo hostnamectl set-hostname $2

sudo systemctl enable salt-minion
sudo service salt-minion restart

# sudo salt salt-master state.apply consul.init
# sudo salt '*' state.highstate
