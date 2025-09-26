#!/bin/bash
mnode=$(meshtastic --nodes --show-fields user.id,user.shortName,user.longName | grep "$1")
if [ -n "$mnode" ]; then
        echo "$mnode"
        madd=$(echo "$mnode" | awk -F'│' '{print $3}' | xargs)
        meshtastic --traceroute "$madd"
else
        echo "$1 not found"
fi
