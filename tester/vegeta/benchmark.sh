#!/bin/bash

duration=1s
url='http://localhost:5000'
rate=0
output=false

function usage() {
    echo "Usage: benchmark.sh [flags]
    -d duration, accepts si units (1s, 5m, 10h)
    -u url, base url of benchmark (http://localhost:5000)
    -r rate, req/sec, 0=inf (1000)
    -o output, generates a report
    -h help, shows this menu"
}

while getopts "d:u:r:oh" opt; do
    case $opt in
        d ) duration=$OPTARG;;
        u ) url=$OPTARG;;
        r ) rate=$OPTARG;;
        o ) output=true;;
        h ) usage
        exit 1;;
        *) exit 1;;
    esac
done


source bash_loading_animations.sh

# Run BLA::stop_loading_animation if the script is interrupted
trap BLA::stop_loading_animation SIGINT


nc='\033[0m'           # Text Reset
bold='\033[1;97m'      # White

duration_seconds=$(sed 's/d/*24*3600 +/g; s/h/*3600 +/g; s/m/*60 +/g; s/s/\+/g; s/+[ ]*$//g' <<< $duration | bc)
stage_count=$(ls -1 stages| wc -l | xargs)
estimated_time=$(($stage_count*$duration_seconds))


echo -e "${bold}Starting benchmarks on ${url} for ${duration}/stage${nc}"
echo "Rate: ${rate}"
echo "Stage count: ${stage_count}"
echo "Estimated time: ${estimated_time}s"
echo ""

BLA::start_loading_animation "${BLA_braille_whitespace[@]}"

echo "Starting raw_json"
./stages/raw_json.sh "${url}/raw_json" $duration $rate

echo "Starting parse_url"
./stages/parse_url.sh "${url}/parse_url" $duration $rate



BLA::stop_loading_animation &> /dev/null
echo -e "\n${bold}Finished benchmark"

# Restore terminal cursor
tput cnorm

# ---------------------- REPORT ------------------------------
if [ $output = true ] ; then
    echo -e "Generating report${nc}"
    BLA::start_loading_animation "${BLA_braille_whitespace[@]}"

    vegeta report results/*.bin > report.txt

    BLA::stop_loading_animation &> /dev/null
    echo -e "\n"

    grep report.txt -e "Requests" -e "Duration" -e "Latencies" -e "Bytes" -e "Success" -e "Status"
    # vegeta plot results/*.bin > plot.html


    #vegeta report -type=json results.bin > metrics.json
    #cat results.bin | vegeta plot > plot.html
    #cat results.bin | vegeta report -type="hist[0,100ms,200ms,300ms]"
fi