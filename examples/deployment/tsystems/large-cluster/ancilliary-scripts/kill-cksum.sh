#!/bin/bash
ids=`ps auxww | egrep ' [c]ksum ' | awk '{ print $2 }'`
if [ "$ids" == "" ]; then
  exit 0
fi

echo kill $ids
kill $ids
