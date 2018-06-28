#!/bin/bash

set -ex

sshconf=/etc/ssh/sshd_config

/usr/bin/mv $sshconf{,.sav}
/usr/bin/cat $sshconf.sav | \
  /usr/bin/egrep -v AllowTcpForwarding | \
  /usr/bin/tee $sshconf >/dev/null

echo 'AllowTcpForwarding yes' >> $sshconf

/usr/bin/chmod 0600 $sshconf

systemctl restart sshd.service
