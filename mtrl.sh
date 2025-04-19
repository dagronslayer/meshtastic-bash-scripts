#!/bin/bash

# Interval between traces. Default is 900 seconds (15 minutes).
interval="900"

[ ! -d ./log ] && mkdir ./log
if [ -f ./log/mtrl.log ]; then
    read -e -p "Clear current logs? (y/n) " choice
    [[ "$choice" == [Yy]* ]] && rm ./log/*.log
fi

mnode=$(meshtastic --nodes | grep "$1")
if [ -n "$mnode" ]; then
        echo "$mnode"
        madd=$(echo "$mnode" | head -1 | tr '│' '^' | cut -d'^' -f10 | xargs)
        while true; do
                mtb=$(date +%s)
                mout=$(/usr/local/bin/meshtastic --traceroute "$madd")
                mte=$(date +%s)
                mtt=$(expr $mte - $mtb)
                mout2=$(echo $mout | grep "Aborting")
                if [ -n "$mout2" ]; then
                echo "${mtb}|${1}|fail|${mtt}" >> ./log/mtrl.log
                else
                        echo "${mtb}|${1}|success|${mtt}" >> ./log/mtrl.log
                fi
                echo "${mtb}|${mout}" >> ./log/mtrd.log
                sleep "$interval";
        done
else
        echo "$1 not found"
fi
