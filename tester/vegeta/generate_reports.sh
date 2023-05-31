#!/bin/bash

readarray -t results <<< $(ls -1)

vegeta report * > result_all.txt

for result in "${results[@]}"; do

    if [[ $result != *.bin ]]; then
        continue
    fi
    echo $result

    vegeta report $result > "result_${result}.txt"
done
