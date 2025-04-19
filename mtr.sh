#!/bin/bash
mnode=$(meshtastic --nodes | grep "$1")
if [ -n "$mnode" ]; then
        echo "$mnode"
        madd=$(echo "$mnode" | head -1 | tr '│' '^' | cut -d'^' -f10 | xargs)
        meshtastic --traceroute "$madd"
else
        echo "$1 not found"
fi
