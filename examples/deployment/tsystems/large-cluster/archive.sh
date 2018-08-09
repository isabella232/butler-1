#!/bin/bash

root=/data/OTC-EMBL/Tony/archive
timestamp=`date +%Y-%m-%d-%H:%M:%S`

set -ex
target="$root/$timestamp"
mkdir -p $target

salt 'worker-0' cmd.run "mkdir -p $target"
salt 'w*' cmd.run "/data/OTC-EMBL/Tony/archive.sh $target"
salt 'worker-0' cmd.run "tar cvf /home/linux/$timestamp.tar $target"
