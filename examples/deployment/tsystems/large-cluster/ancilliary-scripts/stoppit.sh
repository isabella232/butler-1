#!/bin/bash

for pid in `ps auxww | egrep '/usr/local/bin/[f]reebayes' | grep -v /bin/sh | awk '{ print $2 }'`
do
  echo $pid
  kill -CONT $pid
done
