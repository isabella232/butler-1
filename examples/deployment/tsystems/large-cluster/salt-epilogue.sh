#!/bin/bash

set -x
sudo salt-run mine.update '*'
sudo salt-run state.orchestrate butler.deploy

# sudo ./setup-grafana.sh && /usr/bin/true # Finesse the errors

#
# client should already be mounted...
# # sudo salt 'worker-*' cmd.run 'sudo /home/linux/mount-oneclient.sh'

# sudo salt 'worker-*' cmd.run 'sudo /home/linux/set-freebayes-reference-genome.sh'
#
# Don't need the following if the reference genome was set correctly above...
#
# refdata=/opt/butler/examples/data/ref
# sudo salt 'worker-*' cmd.run "sudo tar --directory $refdata -xvf $refdata/human_g1k_v37.20.fasta.tar.gz"

#
# For some reason, seem to need this now...
# sudo salt 'worker-*' state.apply biotools.freebayes

#
# Set up the large-scale tests
# analysis=/opt/butler/examples/analyses/freebayes-discovery
# sudo salt 'tracker' cmd.run "sudo mv $analysis/run-config{,.sav}"
# sudo salt 'tracker' cmd.run "sudo tar --directory $analysis -xvf $analysis/run-config.tgz"
