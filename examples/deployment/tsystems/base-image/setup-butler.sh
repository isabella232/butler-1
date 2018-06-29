#!/bin/bash

set -ex
workdir=/opt/
mkdir -p $workdir
# chmod 777 $workdir
cd $workdir
git clone https://github.com/EMBL-EBI-TSI/butler.git
