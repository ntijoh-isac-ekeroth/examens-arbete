#!/bin/bash

echo "" > targets/parse_url_targets.list
for i in $(seq 1 500); do echo "GET ${1}/${i}"; done >> targets/parse_url_targets.list

vegeta attack -targets=targets/parse_url_targets.list -duration=$2 -rate=$3 -max-workers=$4 -output="results/parse_url_${2}_${3}.bin"
