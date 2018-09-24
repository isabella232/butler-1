#!/bin/bash

./scp.sh worker-0 &
./scp.sh worker-1 &
./scp.sh worker-2 &
./scp.sh worker-3 &
./scp.sh worker-4 &
./scp.sh worker-5 &
./scp.sh worker-6 &
./scp.sh worker-7 &
./scp.sh worker-8 &
./scp.sh worker-9 &
wait
echo "Next round..."
sleep 1

for j in {1,2,3,4,5,6,7,8,9}
do
  ./scp.sh worker-${j}0 &
  ./scp.sh worker-${j}1 &
  ./scp.sh worker-${j}2 &
  ./scp.sh worker-${j}3 &
  ./scp.sh worker-${j}4 &
  ./scp.sh worker-${j}5 &
  ./scp.sh worker-${j}6 &
  ./scp.sh worker-${j}7 &
  ./scp.sh worker-${j}8 &
  ./scp.sh worker-${j}9 &
  wait
  sleep 1
  echo "Next round..."
done

for j in {1,2}{0,1,2,3,4,5,6,7,8,9}
do
  ./scp.sh worker-${j}0 &
  ./scp.sh worker-${j}1 &
  ./scp.sh worker-${j}2 &
  ./scp.sh worker-${j}3 &
  ./scp.sh worker-${j}4 &
  ./scp.sh worker-${j}5 &
  ./scp.sh worker-${j}6 &
  ./scp.sh worker-${j}7 &
  ./scp.sh worker-${j}8 &
  ./scp.sh worker-${j}9 &
  wait
  sleep 1
  echo "Next round..."
done
