#!/bin/bash

#u=`uptime | sed -e 's%^.*average: %%' -e 's%\..*$%%'`
#if [ $u -gt 4 ]; then
#  echo Node is healthy
#else
#  echo Cull freebayes
  kill `ps auxww | egrep '/usr/local/bin/freebaye[s]' | awk '{ print $2 }'`
#fi
