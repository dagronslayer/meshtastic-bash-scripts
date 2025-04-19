# meshtastic-bash-scripts

# mtr.sh <node name, short name, id...>
Grep any unique parameter from the `meshtastic --nodes` results and run a traceroute on the row it matches. No more manually searching for hex node ids.

# mtrl.sh <node name, short name, id...>
Run traceroutes on a defined interval (default is every 15 minutes for 12 hours) and logs the results.

# mtrl_stats.sh
Quick stats on mtrl results. This also returns the mean SNR. Useful for evaluating recorded improvement with different antennas, etc. Requires bc

Example output:
`-6.25dB
-7.25dB
...
Successful traces: 7
Failed traces: 1
87% Success
-6.64dB mean SNR from 7 recorded values`

# mlog_stats.sh
This parses the tail (default 5000 rows) of the /var/log/meshtasticd.json log and returns which nodes have produced the most activity (from field). I wrote this to determine who was causing my high channel utilization.

Example output:
`74e59f1e  -  1191
8487cea8  -  513
eba81f55  -  359
6782905a  -  350
eb5de3e2  -  275
eba4d26b  -  245
eb262843  -  237
67e2f2c2  -  207
...`
