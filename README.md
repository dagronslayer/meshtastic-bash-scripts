# meshtastic-bash-scripts

## mtr.sh <node name, short name, id...>
Grep any unique parameter from the `meshtastic --nodes` results and run a traceroute on the row it matches. No more manually searching for hex node ids.

## mtrl.sh <node name, short name, id...>
Run traceroutes on a defined interval (default is every 15 minutes for 12 hours) and logs the results.

## mtrl_stats.sh
Quick stats on mtrl results. This also returns the mean SNR. Useful for evaluating recorded improvement with different antennas, etc. Requires bc

Example output:
```
Outbound SNR values:
-0.5dB
-0.75dB
-1.25dB
...

Inbound SNR values:
-16.0dB
-17.25dB
-10.75dB
...

Successful traces: 38
Failed traces: 10
79% Success
Outbound: -2.20dB mean SNR from 38 recorded values
Inbound: -9.96dB mean SNR from 38 recorded values
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
