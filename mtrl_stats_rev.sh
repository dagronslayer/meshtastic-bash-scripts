#!/bin/bash

if ! command -v bc 2>&1 >/dev/null
then
    echo "bc could not be found"
    exit 1
fi

if [ ! -f ./mtrl_log/mtrd.log ] || [ ! -f ./mtrl_log/mtrl.log ]; then
    echo "no mtrl logs found"
    exit 1
fi

echo "Outbound SNR values:"
grep -i -A 1 'Route traced towards destination' ./mtrl_log/mtrd.log  | grep \\'-->' | grep -o '[^(]*$' | cut -d ')' -f 1 | grep -v '?dB' 
osnrc=$(grep -i -A 1 'Route traced towards destination' ./mtrl_log/mtrd.log  | grep \\'-->' | grep -o '[^(]*$' | cut -d ')' -f 1 | grep -v '?dB'  | wc -l)
echo ""
echo "Inbound SNR values:"
grep -i -A 1 'Route traced back to us' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '^[^)]*' | cut -d '(' -f 2 | grep -v '?dB'
isnrc=$(grep -i -A 1 'Route traced back to us' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '^[^)]*' | cut -d '(' -f 2 | grep -v '?dB'| wc -l)

success=$(cat ./mtrl_log/mtrl.log | grep "success" | wc -l)
fail=$(cat ./mtrl_log/mtrl.log | grep "fail" | wc -l)
total=$(($success + $fail))

echo ""
echo "Successful traces: $success"
echo "Failed traces: $fail"
echo "$(( 100*$success/$total ))% Success"

hold=true
for i in $(grep -i -A 1 'Route traced towards destination' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '[^(]*$' | cut -d 'd' -f 1 | grep -v '?' | grep -v '-'); do
    if [ "$hold" = true ]; then
        o="$i"
        hold=false
    else
        o="$o + $i"
    fi
done
if [[ -n "$o" ]]; then
    opsnrt=$(echo "$o" | bc)
else
    opsnrt="0"
fi

hold=true
for i in $(grep -i -A 1 'Route traced towards destination' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '[^(]*$' | cut -d 'd' -f 1 | grep -v '?' | grep '-'); do
    if [ "$hold" = true ]; then
        o="$i"
        hold=false
    else
        o="$o + $i"
    fi
done
if [[ -n "$o" ]]; then
    onsnrt=$(echo "$o" | bc)
else
    onsnrt="0"
fi

osnrt=$(echo "$opsnrt + $onsnrt" | bc)
osnrtm=$(echo "scale=2; $osnrt / $osnrc" | bc)

echo "Outbound: ${osnrtm}dB mean SNR from ${osnrc} recorded values"

hold=true
for i in $(grep -i -A 1 'Route traced back to us' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '^[^)]*' | cut -d '(' -f 2 | cut -d 'd' -f 1 | grep -v '?' | grep -v '-'); do
    if [ "$hold" = true ]; then
        o="$i"
        hold=false
    else
        o="$o + $i"
    fi
done
if [[ -n "$o" ]]; then
    ipsnrt=$(echo "$o" | bc)
else
    ipsnrt="0"
fi

hold=true
for i in $(grep -i -A 1 'Route traced back to us' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '^[^)]*' | cut -d '(' -f 2 | cut -d 'd' -f 1 | grep -v '?' | grep '-'); do
    if [ "$hold" = true ]; then
        o="$i"
        hold=false
    else
        o="$o + $i"
    fi
done
if [[ -n "$o" ]]; then
    insnrt=$(echo "$o" | bc)
else
    insnrt="0"
fi

isnrt=$(echo "$ipsnrt + $insnrt" | bc)
isnrtm=$(echo "scale=2; $isnrt / $isnrc" | bc)

echo "Inbound: ${isnrtm}dB mean SNR from ${isnrc} recorded values"
