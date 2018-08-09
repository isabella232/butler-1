#!/bin/bash

tmp=/home/linux/monitor.tmp
log=/home/linux/monitor.log
[ -f $tmp ] && sudo /bin/rm -f $tmp

while true
do
  salt 'w*' cmd.run 'ls /var/log/airflow/freebayes/*/* 2>/dev/null' 2>/dev/null | tee $tmp >/dev/null
  (
    for f in `cat $tmp | grep /var/log/airflow/freebayes | awk -F/ '{ print $6 }' | sort | uniq`
    do
      echo $f `grep -c $f/ $tmp`
    done
    echo freebayes_\* `grep -c airflow/freebayes/freebayes_ $tmp`
    echo ' '
  ) | tee -a $log
  sleep 60
done
