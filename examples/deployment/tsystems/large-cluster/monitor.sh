#!/bin/bash

log=/home/linux/monitor.txt
[ -f $log ] && sudo /bin/rm -f $log

while true
do
  salt 'w*' cmd.run 'ls /var/log/airflow/freebayes/*/* 2>/dev/null' | tee $log >/dev/null
  for f in `cat $log | grep /var/log/airflow/freebayes | awk -F/ '{ print $6 }' | sort | uniq`
  do
    echo $f `grep -c $f/ $log`
  done
  echo freebayes_\* `grep -c airflow/freebayes $log`
  echo ' '
  sleep 60
done
