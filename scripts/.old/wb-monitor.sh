#!/usr/bin/env bash

INTERVAL=1

while true; do
    clear

    echo "===== Waybar Monitor ====="
    echo "$(date)"
    echo

    ID_PID=$(pgrep -x waybar)

    if [[ -z "$ID_PID" ]]; then
        echo "Waybar is not running"
        sleep "$INTERVAL"
        continue
    fi

    echo "PID: $ID_PID"
    echo

    echo "CPU / RAM:"
    ps -p "$ID_PID" -o %cpu,%mem,rss,cmd

    echo

    echo "Threads:"
    ps -o nlwp= -p "$ID_PID"

    echo

    echo "Memory:"
    grep VmRSS /proc/"$ID_PID"/status

    sleep "$INTERVAL"
done
