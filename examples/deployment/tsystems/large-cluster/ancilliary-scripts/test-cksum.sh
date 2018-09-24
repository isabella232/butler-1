#!/bin/bash

idx=`hostname | awk -F- '{ print $2 }'`
end=`expr 3 \* $idx + 3`
echo $end
cksum `cat /home/linux/list.txt 2>/dev/null | head -$end | tail -3`
