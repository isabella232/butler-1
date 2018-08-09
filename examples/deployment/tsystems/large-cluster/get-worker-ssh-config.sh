#!/bin/bash

identity=${identity:=~/.ssh/tony-bastion.pem}
user=${user:=linux}

sudo salt 'worker-*' cmd.run '/sbin/ifconfig eth0' | \
  egrep '^worker|inet ' | \
  sed \
    -e "s%^\s*inet\s*%%" \
    -e "s%\s.*$%%" \
    -e "s%^worker%\nHost worker%" \
    -e "s%:%%" \
    -e 's%^1%  HostName 1%' | \
  tee ssh-config

[ -f ~/.ssh/config ] && /bin/rm -f ~/.ssh/config
(
  echo "Host *"
  echo "  User ${user}"
  echo "  StrictHostKeyChecking no"
  echo "  IdentityFile ${identity}"
  echo "  UserKnownHostsFile /dev/null"
  echo " "
  cat ssh-config | grep -v ProxyCommand
) | tee ~/.ssh/config >/dev/null
chmod 400 ~/.ssh/config
