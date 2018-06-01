#!/bin/bash

salt 'worker-*' cmd.run '/sbin/ifconfig eth0' | \
  egrep '^worker|inet ' | \
  sed \
    -e 's%^\s*inet\s*%%' \
    -e 's%\s.*$%%' \
    -e 's%^worker%\nHost worker%' \
    -e 's%:%%' \
    -e 's%^1%  ProxyCommand ssh t-bastion -W \%h:\%p\n  Hostname 1%'
