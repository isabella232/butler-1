#!/bin/bash

token=$1
if [ "$token" == "" ]; then
  echo "No token given!"
  exit 1
fi

#
# This would be nice, but onedata broke the logic :-(
# Instead of using 18.02.0.rc8, as deduced, I have to
# use...
vsn="oneclient-18.02.0.rc8-1.el7.centos.x86_64"
#
# Beaurk!
#
#vsn=$2
#if [ "$vsn" == "" ]; then
#  vsn="18.02.0.rc8"
#fi
#vsn="oneclient-${vsn}"

if [ ! -f /usr/bin/oneclient ]; then
  curl -sS -o oneclient.sh http://get.onedata.org/oneclient.sh
  chmod +x oneclient.sh
  sudo ./oneclient.sh $vsn
fi

sudo mkdir -p /data

count=3
while [ $count -gt 0 ];
do
  if [ ! -d /data/OTC-EMBL ]; then
    sudo oneclient -i -H ebi-otc.onedata.hnsc.otc-service.com \
      -t $token \
      /data --force-direct-io \
      -o allow_other \
      --force-fullblock-read \
      --rndrd-prefetch-cluster-window=10485760 \
      --rndrd-prefetch-cluster-block-threshold=5 \
      --provider-timeout=7200 \
      -v 1
  fi
  if [ -d /data/OTC-EMBL ]; then
    exit 0
  fi

  count=`expr $count - 1`
  echo "Mount failed, trying again in a few seconds"
  sleep $((RANDOM % 10 + 3 ))
done
