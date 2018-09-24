#!/bin/bash
#
# This is on the worker
#

node=`hostname`
target=$1

pause=`hostname | cut -d- -f2`

tgz=${target}.${node}.tgz
tar --force-local -zcvf $tgz /var/log/airflow/freebayes

echo Sleep for $pause seconds
sleep $pause

scp $tgz bastion:
/bin/rm -f $tgz
