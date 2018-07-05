#!/bin/bash

vsn=`wget --quiet -O - https://ebi-otc.onedata.hnsc.otc-service.com/configuration | sed -e 's%^.*version":"%%' -e 's%".*$%%'`

echo "{ \"vsn\": \"$vsn\" }"
