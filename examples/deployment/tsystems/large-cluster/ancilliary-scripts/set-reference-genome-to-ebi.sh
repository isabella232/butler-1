#!/bin/bash

cd /opt/butler/examples/data/ref/
mv human_g1k_v37.20.fasta{,.sav}
ln -s /data/OTC-EMBL/Tony/human_g1k_v37.20.fasta .
ls -l
