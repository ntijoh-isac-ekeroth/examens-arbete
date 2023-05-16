#!/opt/homebrew/bin/bash
##!/bin/bash

duration=30s
url='http://localhost:7777'
rate=0
max_workers=100
mode="full" # full, skip, only, low_load

# sets stages to all stages if no stages are specified
readarray -t all_stages <<< $(ls -1 stages)


function usage() {
    echo "Usage: benchmark.sh [flags]
    -h                 Show help menu
    -l                 List all available stages
    -m <mode>          Mode: full, skip, only, low_load (full)
    -r <rate>          Requests per second, 0=inf (0)
    -s <stages>        Stages to include/exclude as JSON array, e.g., '["raw_json", "parse_url", "delay"]' (all)
    -t <duration>      Duration in si units (1s, 5m, 10h)
    -u <url>           Base URL of benchmark (http://localhost:5000)
    -w <max_workers>   Maximum number of workers for vegeta (100)"
    exit 1
}

while getopts "hlm:r:s:t:u:w:" opt; do
    case $opt in
        h) usage;;
        l) echo $(ls -1 stages); exit 1;;
        m) mode=$OPTARG;;
        r) rate=$OPTARG;;
        s) readarray -t selected_stages <<< $(jq .[] <<< $OPTARG);;
        t) duration=$OPTARG;;
        u) url=$OPTARG;;
        w) max_workers=$OPTARG;;
        *) exit 1;;
    esac
done



# Remove / from end of url if included by the user

nc='\033[0m'           # Text Reset
bold='\033[1;97m'      # Bold White


duration_seconds=$(sed 's/d/*24*3600 +/g; s/h/*3600 +/g; s/m/*60 +/g; s/s/\+/g; s/+[ ]*$//g' <<< $duration | bc)
url=$(echo $url | sed 's/\/$//')
start_time="$(date -u +%s)"

echo -e "${bold}Starting benchmarks on ${url} for ${duration}/stage${nc}"
echo "Rate: ${rate}"


if [ $mode = 'full' ] ; then
    stage_count=$(ls -1 stages| wc -l | xargs)
    stage_count=$(($stage_count-1))
    estimated_time=$(($stage_count*$duration_seconds))

    echo "Stage count: ${stage_count}"
    echo "Estimated time: ${estimated_time}s"
    echo ""


    for stage in "${all_stages[@]}"; do
        stage=$(sed 's/\.sh$//' <<< $stage)

        echo Starting $stage
        ./stages/$stage.sh "${url}/${stage}" $duration $rate $max_workers
    done
fi



if [ $mode = 'only' ] ; then
    stage_count=$( echo "${selected_stages[@]}" | wc -w | xargs)
    estimated_time=$(($stage_count*$duration_seconds))
    echo "Stage count: ${stage_count}"
    echo "Estimated time: ${estimated_time}s"
    echo ""

    for stage in "${selected_stages[@]}"; do
        # strip surrounding qoutes from $stage
        stage=$(echo $stage | sed 's/^"\(.*\)"$/\1/')
        # strip .sh from $stage
        stage=$(echo $stage | sed 's/\.sh$//')

        echo Starting $stage
        ./stages/$stage.sh "${url}/${stage}" $duration $rate $max_workers "${all_stages[@]}"
    done
fi



contains() {
    # echos true if the last argument is in the array of all arguments except the
    [[ "${@:1:$#-1}.sh" =~ "${@:$#}" ]] && echo 'true'
}

if [ $mode = 'skip' ] ; then
    _total_stages=$(ls -1 stages| wc -l | xargs)
    _total_stages=$(($_total_stages-1))
    _skipped_stages=$(echo "${selected_stages[@]}" | wc -w | xargs)

    stage_count=$(bc <<< "$_total_stages - $_skipped_stages")
    estimated_time=$(($stage_count*$duration_seconds))

    echo "Stage count: ${stage_count}"
    echo "Estimated time: ${estimated_time}s"
    echo ""


    for stage in "${all_stages[@]}"; do
        stage=$(sed 's/\.sh$//' <<< $stage)

        # skips the stage if it is in the selected_stages array
        if [[ $(contains "${selected_stages[@]}" $stage) = 'true' ]] ; then continue ; fi

        echo Starting $stage
        ./stages/$stage.sh "${url}/${stage}" $duration $rate $max_workers
    done
fi

if [ $mode = 'low_load' ] ; then
    _total_stages=$(ls -1 stages| wc -l | xargs)
    _total_stages=$(($_total_stages-1))
    _skipped_stages=$(echo "${selected_stages[@]}" | wc -w | xargs)

    stage_count=$(bc <<< "$_total_stages - $_skipped_stages")
    estimated_time=$(($stage_count*$duration_seconds*2))

    echo "Stage count: ${stage_count} ($(($stage_count * 2)) including low_load)"
    echo "Estimated time: ${estimated_time}s"
    echo ""


    ./low_load.sh "${url}/${stage}" $duration $rate $max_workers  "${all_stages[@]}"
fi



end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"

if [ $mode != "low_load" ] ; then
    echo -e "\n${bold}Finished benchmark in ${elapsed}s${nc}"
fi