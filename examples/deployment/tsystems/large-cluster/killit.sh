#!/bin/bash

kill `ps auxww | egrep '/usr/local/bin/freebaye[s]' | awk '{ print $2 }'`
#kill `ps auxww | egrep '/home/linux/[t]race.sh' | grep bash | awk '{ print $2 }'`
