# meshtastic-bash-scripts

## mtr.sh <node name, short name, id...>
Grep any unique parameter from the `meshtastic --nodes` results and run a traceroute on the row it matches. No more manually searching for hex node ids.

## mtrl.sh <node name, short name, id...>
Run traceroutes on a defined interval (default is every 15 minutes for 12 hours) and logs the results.

## mtrl_stats.sh
Quick stats on mtrl results. This also returns the mean SNR. Useful for evaluating recorded improvement with different antennas, etc.
<br/>**Requires bc**

Example output:
```
Outbound SNR values:
-2.5dB
-1.75dB
-3.5dB
...
Inbound SNR values:
-5.75dB
-2.5dB
-12.75dB
...
Successful traces: 42
Failed traces: 6
87% Success
Outbound: -3.28dB mean SNR from 42 recorded values
Inbound: -6.63dB mean SNR from 42 recorded values
```

## mlog_stats.sh
This parses the tail (default 5000 rows) of the /var/log/meshtasticd.json log and returns which nodes have produced the most activity (from field). I wrote this to determine which nodes causing high channel utilization. With the default 5000, this script requires about 2 minutes to execute on a Raspberry Pi 3.
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

## mutil.sh
Prints the average channel and tx air utilization of nodes last heard within 24 hours.
