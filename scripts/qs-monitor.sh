#!/usr/bin/env bash

INTERVAL=1

while true; do
    clear

    echo "===== Quickshell Monitor ====="
    echo "$(date)"
    echo

    QS_PID=$(pgrep -x quickshell)

    if [[ -z "$QS_PID" ]]; then
        echo "Quickshell is not running"
        sleep "$INTERVAL"
        continue
    fi

    echo "PID: $QS_PID"
    echo

    echo "CPU / RAM:"
    ps -p "$QS_PID" -o %cpu,%mem,rss,cmd

    echo

    echo "Threads:"
    ps -o nlwp= -p "$QS_PID"

    echo

    echo "Memory:"
    grep VmRSS /proc/"$QS_PID"/status

    sleep "$INTERVAL"
done
