#!/bin/bash

watch -n5 '
charge=$(cat /sys/class/power_supply/BAT1/charge_now)
current=$(cat /sys/class/power_supply/BAT1/current_now)
voltage=$(cat /sys/class/power_supply/BAT1/voltage_now)
capacity=$(cat /sys/class/power_supply/BAT1/capacity)
status=$(cat /sys/class/power_supply/BAT1/status)

awk -v c="$charge" -v i="$current" -v v="$voltage" \
    -v cap="$capacity" -v status="$status" "BEGIN {
        power=(i*v)/1000000000000

        if (i > 0) {
            hours=c/i
            h=int(hours)
            m=int((hours*60)%60)
            time=sprintf(\"%02d:%02d\", h, m)
        } else {
            time=\"--:--\"
        }

        printf \"%s | %d%% | %.2f W | %s remaining\\n\",
            status, cap, power, time
    }"
'
