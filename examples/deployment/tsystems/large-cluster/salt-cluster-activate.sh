#!/bin/bash

set -x
sudo salt-key --accept-all --yes
sudo salt-run mine.update '*'
# sudo salt 'worker-*' cmd.run '/bin/rm -rf /opt/butler/configuration/salt/state/biotools'
sudo salt-run state.orchestrate butler.deploy

if [ -f ./setup-grafana.sh ]; then
  sudo ./setup-grafana.sh
  /bin/mv setup-grafana.sh{,.sav}
fi

/bin/true # Don't care about errors
