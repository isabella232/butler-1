#!/bin/bash

set -x

analysis=/opt/butler/examples/analyses/freebayes-discovery
sudo mv $analysis/run-config{,.sav}
sudo tar --directory $analysis -xvf $analysis/run-config.tgz
