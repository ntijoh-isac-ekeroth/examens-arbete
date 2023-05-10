#!/bin/bash

echo "" > targets/parse_url_targets.list
./tools/generate_targets.sh 500 $1 >> targets/parse_url_targets.list

vegeta attack -targets=targets/parse_url_targets.list -duration=$2 -rate=$3 -max-workers=100 -output=results/parse_url.bin
