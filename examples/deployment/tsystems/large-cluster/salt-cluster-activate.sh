#!/bin/bash

now=`date +%s`
log=~/deploy.$now.log

set -x
sudo salt-key --accept-all --yes
sudo salt-run mine.update '*'
# sudo salt 'worker-*' cmd.run '/bin/rm -rf /opt/butler/configuration/salt/state/biotools'
(
  echo "Start: `date +%s`"
  sudo salt '*' test.ping

#  sudo salt-run state.orchestrate butler.deploy
  sudo salt-run --log-level=info --no-colour state.orchestrate butler.deploy
  echo "Stop: `date +%s`"
) 2>&1 | tee $log

if [ -f ./setup-grafana.sh ]; then
  sudo ./setup-grafana.sh
  /bin/mv setup-grafana.sh{,.sav}
fi

/bin/true # Don't care about errors
