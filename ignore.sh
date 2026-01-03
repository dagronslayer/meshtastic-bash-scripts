#!/bin/bash
mnode=$(meshtastic --nodes --show-fields user.id,user.shortName,user.longName | grep "$1")
if [ -n "$mnode" ]; then
        echo "$mnode"
        madd=$(echo "$mnode" | head -1 | awk -F'│' '{print $3}' | xargs)
        if [[ -f "ra.lst" ]]; then
            while IFS= read -r radd; do
                echo "meshtastic --set-ignored-node \"$madd\" --dest \"$radd\""
                out=$(meshtastic --set-ignored-node "$madd" --dest "$radd")
                echo "$out"
                sleep 30
            done < "ra.lst"
        else
            echo "ra.lst not found"
            exit 1
        fi
else
        echo "$1 not found"
fi
