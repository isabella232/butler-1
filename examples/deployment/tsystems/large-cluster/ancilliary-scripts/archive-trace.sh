#!/bin/bash

node=`hostname`
target=$1

cd /home/linux
log=${target}.${node}.log
mv trace.log $log
pbzip2 $log

pause=`hostname | cut -d- -f2`
echo Sleep for $pause seconds
sleep $pause

scp $log.bz2 bastion:
