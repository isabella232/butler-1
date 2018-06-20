#!/bin/bash

bastion=$1
identity=$2
user=$3

salt 'worker-*' cmd.run '/sbin/ifconfig eth0' | \
  egrep '^worker|inet ' | \
  sed \
    -e "s%^\s*inet\s*%%" \
    -e "s%\s.*$%%" \
    -e "s%^worker%\nHost worker%" \
    -e "s%:%%" \
    -e "s%^1%  ProxyCommand ssh -i ${identity} ${user}@${bastion} -W \%h:\%p\n  Hostname 1%" | \
  tee ssh-config
