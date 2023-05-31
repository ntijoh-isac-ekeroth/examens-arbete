#!/bin/bash

echo "" > targets/post_read_targets.list
echo "
POST ${1}
Content-Type: application/json
@bodies/hello_world.json
" >> targets/post_read_targets.list

vegeta attack -targets=targets/post_read_targets.list -duration=$2 -rate=$3 -max-workers=$4 -output="results/post_read_${2}_${3}.bin"