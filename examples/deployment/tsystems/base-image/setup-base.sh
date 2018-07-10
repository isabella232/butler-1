#!/bin/bash

REAL_USER=$1
if [ "$REAL_USER" == "" ]; then
  REAL_USER=$SUDO_USER
fi
if [ "$REAL_USER" == "" ]; then
  echo "Need to know who the real user is?"
  exit 1
fi
echo Real user is $REAL_USER

set -ex
yum install -y epel-release
yum -y update
yum install -y python-pip git python-pygit2 wget yum-plugin-priorities
yum install -y gcc gcc-c++ make cmake kernel-devel zlib-devel bzip2 bzip2-devel xz-devel
yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
yum install -y salt-minion
systemctl disable firewalld
systemctl stop firewalld
yum clean expire-cache
patch -p0 /etc/salt/minion /home/$REAL_USER/minion.patch
(
  echo '* hard nofile 1048576'
  echo '* soft nofile 1048576'
) | sudo tee -a /etc/security/limits.conf
