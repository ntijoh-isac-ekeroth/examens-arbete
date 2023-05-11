#!/bin/bash

echo "GET" $1 | vegeta attack -duration=$2 -rate=$3 -max-workers=$4 -output=results/raw_json.bin
