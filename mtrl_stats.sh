#!/bin/bash

if ! command -v bc 2>&1 >/dev/null
then
    echo "bc could not be found"
    exit 1
fi

if [ ! -f ./log/mtrd.log ] || [ ! -f ./log/mtrl.log ]; then
    echo "no mtrl logs found"
    exit 1
fi


grep \\'-->' ./log/mtrd.log | grep -o '[^(]*$' | cut -d ')' -f 1 | grep -v '?dB'
snrc=$(grep \\'-->' ./log/mtrd.log | grep -o '[^(]*$' | cut -d ')' -f 1 | grep -v '?dB' | wc -l)

success=$(cat ./log/mtrl.log | grep "success" | wc -l)
fail=$(cat ./log/mtrl.log | grep "fail" | wc -l)
total=$(($success + $fail))

echo ""
echo "Successful traces: $success"
echo "Failed traces: $fail"
echo "$(( 100*$success/$total ))% Success"

# psnrc=$(grep \\'-->' ./log/mtrd.log | grep -o '[^(]*$' | cut -d 'd' -f 1 | grep -v '?' | grep -v '-' | wc -l)
# nsnrc=$(grep \\'-->' ./log/mtrd.log | grep -o '[^(]*$' | cut -d 'd' -f 1 | grep -v '?' | grep '-' | wc -l)

hold=true
for i in $(grep \\'-->' ./log/mtrd.log | grep -o '[^(]*$' | cut -d 'd' -f 1 | grep -v '?' | grep -v '-'); do
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
for i in $(grep \\'-->' ./log/mtrd.log | grep -o '[^(]*$' | cut -d 'd' -f 1 | grep -v '?' | grep '-'); do
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
snrtm=$(echo "$snrt / $snrc" | bc)

echo "${snrtm}dB mean SNR from ${snrc} recorded values"
