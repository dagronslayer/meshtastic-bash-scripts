# meshtastic-bash-scripts
Helpful bash scripts for meshtastic and meshtasticd

# mtr.sh <node name, short name, id...>
Grep any unique parameter from the `meshtastic --nodes` results and run a traceroute on the row it matches. No more manually searching for hex node ids.

# mtrl.sh <node name, short name, id...>
Run traceroutes on a defined interval (default is every 15 minutes). Logs the results in a directory it creates (./logs).

# mtrl_stats.sh
Quick stats on mtrl results. This also returns the mean SNR. Useful for evaluating recorded improvement with different antennas, etc. Requires bc

# mlog_stats.sh
This parses the tail (default 5000 rows) of the /var/log/meshtasticd.json log and returns which nodes have produced the most activity (from field). I wrote this to determine who was causing my high channel utilization.
