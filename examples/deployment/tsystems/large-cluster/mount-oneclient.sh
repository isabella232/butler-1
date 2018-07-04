#!/bin/bash

token=$1
if [ "$token" == "" ]; then
  echo "No token given!"
  exit 1
fi

vsn=$2
if [ "$vsn" == "" ]; then
  vsn="oneclient-18.02.0.rc8"
fi

if [ ! -f /usr/bin/oneclient ]; then
  curl -sS -o oneclient.sh http://get.onedata.org/oneclient.sh
  chmod +x oneclient.sh
  sudo ./oneclient.sh $vsn
fi

sudo mkdir -p /data

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
