#!/bin/bash

mkdir -p trace
for i in {0,1,2,3,4,5,6,7,8,9} {1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9} {1,2}{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
do
  scp worker-${i}:trace.log trace/worker-${i}.trace.log
  pbzip2 -v trace/worker-${i}.trace.log
done
