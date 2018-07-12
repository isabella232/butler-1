#!/bin/bash

cd /opt/butler/examples/data/ref/

[ -f human_g1k_v37.20.fasta ] &&  mv human_g1k_v37.20.fasta{,.sav}
#ln -s /data/OTC-EMBL/Tony/human_g1k_v37.fasta human_g1k_v37.20.fasta
/bin/cp -i /data/OTC-EMBL/Tony/human_g1k_v37.fasta human_g1k_v37.20.fasta

[ -f human_g1k_v37.20.fasta.fai ] &&  mv human_g1k_v37.20.fasta.fai{,.sav}
#ln -s /data/OTC-EMBL/Tony/human_g1k_v37.fasta.fai human_g1k_v37.20.fasta.fai
/bin/cp -i /data/OTC-EMBL/Tony/human_g1k_v37.fasta.fai human_g1k_v37.20.fasta.fai
