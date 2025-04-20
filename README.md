# meshtastic-bash-scripts

## mtr.sh <node name, short name, id...>
Grep any unique parameter from the `meshtastic --nodes` results and run a traceroute on the row it matches. No more manually searching for hex node ids.

## mtrl.sh <node name, short name, id...>
Run traceroutes on a defined interval (default is every 15 minutes for 12 hours) and logs the results.

## mtrl_stats.sh
Quick stats on mtrl results. This also returns the mean SNR. Useful for evaluating recorded improvement with different antennas, etc. Requires bc

Example output:
```
-5.5dB
-6.5dB
-6.0dB
...
Successful traces: 45
Failed traces: 10
81% Success
-8.61dB mean SNR from 45 recorded values
```

## mlog_stats.sh
This parses the tail (default 5000 rows) of the /var/log/meshtasticd.json log and returns which nodes have produced the most activity (from field). I wrote this to determine which nodes causing high channel utilization.

Example output:
```
eba81f55  -  392
6782905a  -  376
8487cea8  -  341
eba4d26b  -  312
eb5de3e2  -  283
8f7bd9af  -  265
eb262843  -  250
...
```
