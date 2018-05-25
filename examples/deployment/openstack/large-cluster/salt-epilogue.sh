#!/bin/bash

set -ex
sudo salt-run mine.update '*'                 2>&1 | tee salt.mine.update.log
sudo salt-run state.orchestrate butler.deploy 2>&1 | tee salt.butler.deploy.log
