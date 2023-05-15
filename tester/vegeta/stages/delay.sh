#!/bin/bash

echo "" > targets/delay_targets.list
for i in $(seq 1 5); do echo "GET ${1}/${i}"; done >> targets/delay_targets.list

vegeta attack -targets=targets/delay_targets.list -duration=$2 -rate=$3 -max-workers=$4 -output="results/delay_${2}_${3}.bin"