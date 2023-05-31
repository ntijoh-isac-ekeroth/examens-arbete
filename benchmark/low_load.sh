#!/bin/bash

nc='\033[0m'           # Text Reset
bold='\033[1;97m'      # Bold White
cyan='\033[1;36m'      # Bold Cyan

echo -e "${cyan}Starting Full load Test${nc}"
start_time="$(date -u +%s)"
# Runs a max load test to get maximum throughput for each stage
./benchmark.sh -u $1 -t $2 -r 0 -w $4

echo -e "${cyan}Starting Low load Test${nc}"

url=$1

for stage in "${@:5:$#}"; do
# for stage in "${@:$#:$#}"; do
    stage=$(sed 's/\.sh$//' <<< $stage)

    # Matches on the stage name and and a rate of 0
    # Take the last line to ensure the longest duration test is used
    # file=$(ls ./results | grep -E "^${stage}_\d+\w_0.bin$" | tail -n 1)

    file="${stage}_${2}_0.bin"

    rate=$(jq .throughput <<< $(vegeta report -type=json "results/${file}"))
    rate=$(bc <<< "$rate * 0.1")
    rate=$(printf "%.*f\n" 0 "$rate")

    if [ $rate -lt 1 ]; then
        rate=1
    fi

    echo Starting $stage

    # Stage, URL, Duration, Rate, Max Workers
    ./stages/$stage.sh "${url}${stage}" $2 $rate $4

done

end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"

echo -e "\n${cyan}Finished benchmark in ${elapsed}s${nc}"

