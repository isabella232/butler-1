#!/bin/bash

set -ex
sudo salt-run mine.update '*'                 2>&1 | tee salt.mine.update.log
# sudo salt-run state.orchestrate butler.deploy 2>&1 | tee salt.butler.deploy.log

# sudo ./setup-grafana.sh

# sudo salt 'worker-*' cmd.run 'sudo tar --directory /opt/butler/examples/data/ref -xvf /opt/butler/examples/data/ref/human_g1k_v37.20.fasta.tar.gz'
