#!/bin/bash

echo "GET" $1 | vegeta attack -duration=$2 -rate=$3 -max-workers=100 -output=results/raw_json.bin
