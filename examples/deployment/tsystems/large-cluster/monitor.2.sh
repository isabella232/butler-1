#!/bin/bash

log=/home/linux/monitor.2.log

while true
do
  salt 'worker-*' cmd.run 'ps auxww | egrep "/usr/local/bin/freeba[y]es" | egrep -v " -c /usr" | wc -l' | \
    tee bbb >/dev/null
  total=0
  now=`date +%Y-%m-%d-%H-%M-%S`
  (
    echo $now
    for i in 0 1 2 3 4
    do
      j=`cat bbb | egrep -c "   $i"`
      echo $i $j
      total=`expr $total + $i \* $j`
    done
    echo "Total: $total"
    echo ' '
  ) | tee -a $log
  sleep 60
done
