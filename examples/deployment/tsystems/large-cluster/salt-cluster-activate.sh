#!/bin/bash

now=`date +%s`
log=~${SUDO_USER}/deploy.$now.log

waiting=`salt '*' test.ping | tee a | grep -c 'did not return'`
while [ $waiting -ne 0 ]; do
  echo "Waiting for $waiting nodes"
  sleep 30
  waiting=`salt '*' test.ping | tee a | grep -c 'did not return'`
done

set -x
sudo salt-key --accept-all --yes
sudo salt-run mine.update '*'

(
  echo "Start: `date +%s`"
# sudo salt '*' test.ping

#  sudo salt-run state.orchestrate butler.deploy
  sudo salt-run --log-level=info --no-colour state.orchestrate butler.deploy
  echo "Stop: `date +%s`"
) 2>&1 | tee $log

# After that, if I have enough nodes, I need to kick consul:
# salt '*' cmd.run 'sudo service consul restart'

if [ -f ./setup-grafana.sh ]; then
  sudo ./setup-grafana.sh
  /bin/mv setup-grafana.sh{,.sav}
fi

/bin/true # Don't care about errors
