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

grep -i -A 1 'Route traced back to us' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '[^(]*$' | cut -d ')' -f 1 | grep -v '?dB'
snrc=$(grep -i -A 1 'Route traced back to us' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '[^(]*$' | cut -d ')' -f 1 | grep -v '?dB' | wc -l)

success=$(cat ./mtrl_log/mtrl.log | grep "success" | wc -l)
fail=$(cat ./mtrl_log/mtrl.log | grep "fail" | wc -l)
total=$(($success + $fail))

echo ""
echo "Successful traces: $success"
echo "Failed traces: $fail"
echo "$(( 100*$success/$total ))% Success"

hold=true
for i in $(grep -i -A 1 'Route traced back to us' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '[^(]*$' | cut -d 'd' -f 1 | grep -v '?' | grep -v '-'); do
    if [ "$hold" = true ]; then
        o="$i"
        hold=false
    else
        o="$o + $i"
    fi
done
if [[ -n "$o" ]]; then
    psnrt=$(echo "$o" | bc)
else
    psnrt="0"
fi

hold=true
for i in $(grep -i -A 1 'Route traced back to us' ./mtrl_log/mtrd.log | grep \\'-->' | grep -o '[^(]*$' | cut -d 'd' -f 1 | grep -v '?' | grep '-'); do
    if [ "$hold" = true ]; then
        o="$i"
        hold=false
    else
        o="$o + $i"
    fi
done
if [[ -n "$o" ]]; then
    nsnrt=$(echo "$o" | bc)
else
    nsnrt="0"
fi

snrt=$(echo "$psnrt + $nsnrt" | bc)
snrtm=$(echo "scale=2; $snrt / $snrc" | bc)

echo "${snrtm}dB mean SNR from ${snrc} recorded values"
