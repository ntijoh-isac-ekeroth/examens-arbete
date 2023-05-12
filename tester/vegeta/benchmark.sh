#!/opt/homebrew/bin/bash
##!/bin/bash

duration=5s
url='http://localhost:5000'
rate=0
output=true
show_errors=false
skip_benchmarks=false
max_workers=100
mode="full" # full, skip, only

# sets stages to all stages if no stages are specified
readarray -t all_stages <<< $(ls -1 stages)

function usage() {
    echo "Usage: benchmark.sh [flags]
    -d duration, accepts si units (1s, 5m, 10h)
    -u url, base url of benchmark (http://localhost:5000)
    -r rate, req/sec, 0=inf (1000)
    -o output, hides generated report
    -h help, shows this menu
    -e show-errors, show errors in report
    -s skip_benchmarks, skips all benchmarks
    -w max_workers, sets the max amount of workers for vegeta (100)
    -m mode, full, skip, only (full)
    -b stages, json object with stages to include/exclude, example: '["raw_json", "parse_url", "delay"]' (all)
    -l list, list all available stages"
    exit 1
}

# FIXME: This is a mess, but it works
while getopts "d:u:r:ohesw:b:m:l" opt; do
    case $opt in
        d ) duration=$OPTARG;;
        u ) url=$OPTARG;;
        r ) rate=$OPTARG;;
        o ) output=false;;
        h ) usage;;
        e ) show_errors=true;;
        s ) skip_benchmarks=true;;
        w ) max_workers=$OPTARG;;
        m ) mode=$OPTARG;;
        b ) readarray -t selected_stages <<< $(jq .[] <<< $OPTARG);;
        l ) echo $(ls -1 stages); exit 1;;
        * ) exit 1;;
    esac
done




# Remove / from end of url if included by the user
url=$(echo $url | sed 's/\/$//')

# source bash_loading_animations.sh

# # Run BLA::stop_loading_animation if the script is interrupted
# trap BLA::stop_loading_animation SIGINT



nc='\033[0m'           # Text Reset
bold='\033[1;97m'      # Bold White

duration_seconds=$(sed 's/d/*24*3600 +/g; s/h/*3600 +/g; s/m/*60 +/g; s/s/\+/g; s/+[ ]*$//g' <<< $duration | bc)

# clear

if [ $skip_benchmarks = false ] ; then
    start_time="$(date -u +%s)"

    echo -e "${bold}Starting benchmarks on ${url} for ${duration}/stage${nc}"
    echo "Rate: ${rate}"

    # BLA::start_loading_animation "${BLA_braille_whitespace[@]}"


    if [ $mode = 'full' ] ; then
        stage_count=$(ls -1 stages| wc -l | xargs)
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
            stage=$(echo $stage | sed 's/\.sh$//')
            echo Starting $stage
            ./stages/$stage.sh "${url}/${stage}" $duration $rate $max_workers
        done
    fi



    contains() {
        # echos true if the last argument is in the array of all arguments except the
        [[ "${@:1:$#-1}.sh" =~ "${@:$#}" ]] && echo 'true'
    }

    if [ $mode = 'skip' ] ; then
        _total_stages=$(ls -1 stages| wc -l | xargs)
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





    # BLA::stop_loading_animation &> /dev/null

    end_time="$(date -u +%s)"
    elapsed="$(($end_time-$start_time))"

    echo -e "\n${bold}Finished benchmark in ${elapsed}s${nc}"

    # Restore terminal cursor
    tput cnorm
fi

# ---------------------- REPORT ------------------------------
if [ $output = true ] ; then
    echo -e "\n${bold}Generating report${nc}"
    # BLA::start_loading_animation "${BLA_braille_whitespace[@]}"


    # BLA::stop_loading_animation &> /dev/null
    # echo -e "\n"

    if [ $show_errors = true ] ; then
        vegeta report results/*.bin
    else
        grep -e "Requests" -e "Duration" -e "Latencies" -e "Bytes" -e "Success" -e "Status" <<< vegeta report results/*.bin
    fi

    # vegeta plot results/*.bin > plot.html


    #vegeta report -type=json results.bin > metrics.json
    #cat results.bin | vegeta plot > plot.html
    #cat results.bin | vegeta report -type="hist[0,100ms,200ms,300ms]"
fi