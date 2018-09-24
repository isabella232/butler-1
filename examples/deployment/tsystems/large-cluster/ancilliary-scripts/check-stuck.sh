#!/bin/bash

echo $HOSTNAME
for pid in `ps auxww | egrep /usr/local/bin[/]freebayes | awk '{ print $2 }'`
do
  echo pid = $pid
  ls -l `ls -l /proc/$pid/fd | egrep '/var/log/airflow|tmp/results' | awk '{ print $NF }'` \
    | sed -e 's%^.* airflow%%'
done
