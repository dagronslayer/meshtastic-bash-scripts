#!/bin/bash

# Interval between traces. Default is 900 seconds (15 minutes). Default iterations is 48 (12 hours).
interval="900"
iterations="48"

[ ! -d ./mtrl_log ] && mkdir ./mtrl_log
if [ -f ./mtrl_log/mtrl.log ]; then
    read -e -p "Clear current logs? (y/n) " choice
    [[ "$choice" == [Yy]* ]] && rm ./mtrl_log/*.log
fi

mnode=$(meshtastic --nodes --show-fields user.id,user.shortName,user.longName | grep "$1")
if [ -n "$mnode" ]; then
        echo "$mnode"
        madd=$(echo "$mnode" | awk -F'│' '{print $3}' | xargs)
        for(( i=$iterations; i>0; i-=1 )); do
            mtb=$(date +%s)
            mout=$(meshtastic --traceroute "$madd")
            mte=$(date +%s)
            mtt=$(expr $mte - $mtb)
            mout2=$(echo $mout | grep "Aborting")
            if [ -n "$mout2" ]; then
                echo "${mtb}|${1}|fail|${mtt}" >> ./mtrl_log/mtrl.log
            else
                echo "${mtb}|${1}|success|${mtt}" >> ./mtrl_log/mtrl.log
            fi
            echo "${mtb}|${mout}" >> ./mtrl_log/mtrd.log
            sleep "$interval";
        done
else
        echo "$1 not found"
fi
