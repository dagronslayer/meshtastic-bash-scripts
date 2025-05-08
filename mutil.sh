#!/bin/bash

if ! command -v bc 2>&1 >/dev/null
then
    echo "bc could not be found"
    exit 1
fi

results=($(meshtastic --nodes | grep "now\|sec\|min\|\hour" | tr '│' '^' | cut -d'^' -f34 | grep '%' | cut -d '%' -f 1 | xargs))
cresults=${#results[@]}
sum=0
for i in "${results[@]}"; do
  sum=$(echo "$sum + $i" | bc)
done
ave=$(echo "scale=2; $sum / $cresults" | bc)
echo "Average Channel util. from $cresults nodes: ${ave}%"

results=($(meshtastic --nodes | grep "now\|sec\|min\|\hour" | tr '│' '^' | cut -d'^' -f37 | grep '%' | cut -d '%' -f 1 | xargs))
cresults=${#results[@]}
sum=0
for i in "${results[@]}"; do
  sum=$(echo "$sum + $i" | bc)
done
ave=$(echo "scale=2; $sum / $cresults" | bc)
echo "Average Tx air util. from $cresults nodes: ${ave}%"