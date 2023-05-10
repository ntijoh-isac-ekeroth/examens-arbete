#!/bin/bash

for i in $(seq 1 $1); do echo "GET ${2}/${i}"; done