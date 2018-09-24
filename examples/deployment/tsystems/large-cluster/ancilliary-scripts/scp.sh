#!/bin/bash

echo $1
#sleep $((1 + RANDOM % 5))
#scp human_g1k_v37.fasta.bz2 $1:
#scp human_g1k_v37.fasta.fai $1:
#scp killbayes.sh $1:
#scp mount-oneclient.sh $1:
#scp trace.sh $1:
#scp check-stuck.sh $1:
#scp archive-airflow.sh $1:
#scp archive-trace.sh $1:
#scp hosts $1:
#scp list.txt $1:
#scp kill-cksum.sh $1:
scp set-reference-genome-to-ebi.sh $1:
