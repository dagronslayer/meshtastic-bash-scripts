#!/bin/bash

# Number of log lines to process. With the default 5000, this script requires about 2 minutes to execute on a Raspberry Pi 3
logtail="5000"

declare -A oarray

while IFS=':' read -ra iarray; do
    for i in "${!iarray[@]}"; do
        if [[ "${iarray[$i]}" =~ "from" ]]; then
            ((i+=1))
            nname=$(echo "${iarray[$i]}" | cut -d "," -f 1 | xargs printf '%x')
            if [[ -n "${oarray["$nname"]}" ]]; then
                ((oarray["$nname"]+=1))
            else
                oarray["$nname"]="1"
            fi
        fi
    done
done < <(tail -n "$logtail" /var/log/meshtasticd.json)

# Print node ID
# for k in "${!oarray[@]}"; do echo "$k" ' - ' ${oarray["$k"]}; done | sort -nr -k3

# Print node short name
for k in "${!oarray[@]}"; do echo $(meshtastic --nodes | grep "$k" | head -1 | tr '│' '^' | cut -d'^' -f13 | xargs) ' - ' ${oarray["$k"]}; done | sort -nr -k3
