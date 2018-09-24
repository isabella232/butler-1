#!/bin/bash

pids=`ps auxww | egrep '/usr/local/bin/freebaye[s]' | awk '{ print $2 }'`
if [ "$pids" != "" ]; then
  kill `ps auxww | egrep '/usr/local/bin/freebaye[s]' | awk '{ print $2 }'`
fi
#kill `ps auxww | egrep '/home/linux/[t]race.sh' | grep bash | awk '{ print $2 }'`
