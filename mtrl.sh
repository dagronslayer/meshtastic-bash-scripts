#!/bin/bash

# Define usage function
usage() {
    echo "Usage: $0 [-i interval] [-r repeat] [-p port] <required_argument>"
    exit 1
}

# Initialize variables
PORT="" # Set a default value for the port
INTERVAL="900" # default interval 15 minutes
REPEAT="48" # default iterations 12h at 15m intervals

# Process flagged options
while getopts "i®p:" opt; do
  case $opt in
    i) INTERVAL="$OPTARG" ;;
    r) REPEAT="$OPTARG" ;;
    p) PORT="$OPTARG" ;;
    *) usage ;;
  esac
done
# 3. Shift the arguments
# This moves the positional parameters so the required argument becomes $1
shift $((OPTIND - 1))

# 4. Handle the required positional parameter
NODE=$1

if [[ -z "$NODE" ]]; then
    echo "Error: Missing node identifier"
    usage
fi

# the meat of the script
[ ! -d ./mtrl_log ] && mkdir ./mtrl_log
if [ -f ./mtrl_log/mtrl.log ]; then
    read -e -p "Clear current logs? (y/n) " choice
    [[ "$choice" == [Yy]* ]] && rm ./mtrl_log/*.log
fi

# get the node identifier
if [[ -n "$PORT" ]]; then
  mnode=$(meshtastic --port $PORT --nodes --show-fields user.id,user.shortName,user.longName | grep "$NODE")
else
  mnode=$(meshtastic --nodes --show-fields user.id,user.shortName,user.longName | grep "$NODE")
  PORT="default"
fi

# validate with the user the parameters being used
echo "Target: $NODE"
echo "Config: Interval=$INTERVAL, Repeat=$REPEAT, Port=$PORT"

# loop through a Traceroute $REPEAT times
if [ -n "$mnode" ]; then
        echo "$mnode"
        madd=$(echo "$mnode" | awk -F'│' '{print $3}' | xargs)
        for(( i=$REPEAT; i>0; i-=1 )); do
            mtb=$(date +%s)
            mout=$(meshtastic --port $PORT --traceroute "$madd")
            mte=$(date +%s)
            mtt=$(expr $mte - $mtb)
            mout2=$(echo $mout | grep "Aborting")
            if [ -n "$mout2" ]; then
                echo "${mtb}|${1}|fail|${mtt}" >> ./mtrl_log/mtrl.log
            else
                echo "${mtb}|${1}|success|${mtt}" >> ./mtrl_log/mtrl.log
            fi
            echo "${mtb}|${mout}" >> ./mtrl_log/mtrd.log
            sleep "$INTERVAL";
        done
else
        echo "$NODE not found"
fi
