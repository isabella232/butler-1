#!/bin/bash

set -ex
sudo salt-run mine.update '*'                 2>&1 | tee salt.mine.update.log
sudo salt-run state.orchestrate butler.deploy 2>&1 | tee salt.butler.deploy.log

sudo ./setup-grafana.sh && /usr/bin/true # Finesse the errors

sudo salt 'worker-*' cmd.run 'sudo /home/linux/mount-oneclient.sh'
sudo salt 'worker-*' cmd.run 'sudo /home/linux/set-freebayes-reference-genome.sh'
#
# Don't need the following if the reference genome was set correctly above...
#
# refdata=/opt/butler/examples/data/ref
# sudo salt 'worker-*' cmd.run "sudo tar --directory $refdata -xvf $refdata/human_g1k_v37.20.fasta.tar.gz"

analysis=/opt/butler/examples/analyses/freebayes-discovery
sudo salt 'tracker' cmd.run "sudo mv $analysis/run-config/{,.sav}"
sudo salt 'tracker' cmd.run "sudo tar --directory $analysis -xvf $analysis/run-config.tgz"
