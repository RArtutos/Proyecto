#!/bin/bash

function get_processes() {
    ps aux --no-headers | awk '{print "{\"pid\":" $2 ",\"user\":\"" $1 "\",\"cpu\":" $3 ",\"mem\":" $4 ",\"command\":\"" $11 "\"}"}'
}

function stop_process() {
    local pid="$1"
    if [ -n "$pid" ]; then
        kill -15 "$pid" 2>/dev/null
        return $?
    fi
    return 1
}

function format_processes_json() {
    echo "{"
    echo "\"processes\": ["
    get_processes | paste -sd,
    echo "]"
    echo "}"
}