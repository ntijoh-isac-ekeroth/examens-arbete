#!/bin/bash

echo "" > targets/post_read_targets.list
echo "
POST http://localhost:5000/post_read
Content-Type: application/json
@bodies/lorem_ipsum.json
" >> targets/post_read_big_body_targets.list

vegeta attack -targets=targets/post_read_big_body_targets.list -duration=$2 -rate=$3 -max-workers=$4 -output=results/post_read_big_body.bin