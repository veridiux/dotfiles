watch -n1 'awk "BEGIN { c=$(cat /sys/class/power_supply/BAT1/current_now); v=$(cat /sys/class/power_supply/BAT1/voltage_now); printf \"%.2f W\n\", (c*v)/1000000000000 }"'
