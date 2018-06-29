#!/bin/bash

set -x
sudo salt-key --accept-all --yes
sudo salt-run mine.update '*'
sudo salt 'worker-*' cmd.run '/bin/rm -rf /opt/butler/configuration/salt/state/biotools'
sudo salt-run state.orchestrate butler.deploy

# sudo ./setup-grafana.sh
# 
# sudo salt 'worker-*' cmd.run 'sudo /home/linux/set-freebayes-reference-genome.sh'
# 
# #
# # Set up the large-scale tests
# #analysis=/opt/butler/examples/analyses/freebayes-discovery
# #sudo salt 'tracker' cmd.run "sudo mv $analysis/run-config{,.sav}"
# #sudo salt 'tracker' cmd.run "sudo tar --directory $analysis -xvf $analysis/run-config.tgz"
