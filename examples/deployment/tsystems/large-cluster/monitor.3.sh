#!/bin/bash

log=/home/linux/monitor.3.log

while true
do
  (
    echo -n "`date +%Y-%m-%d-%H-%M-%S` "
    salt 'w*' cmd.run 'ls /var/log/airflow/freebayes/*/* | grep freebayes_ 2>/dev/null' 2>/dev/null | wc -l

  ) | tee -a $log
  sleep 60
done
