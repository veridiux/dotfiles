
#!/bin/bash

# ---------------------------------------------------------
# Battery Drain Watcher
# ---------------------------------------------------------
# Automatically detects the system battery.
#
# When launched:
#   - Asks whether to save a log
#   - Records the initial battery percentage
#   - Records another entry every 5% battery lost
#   - Displays live battery information every 5 seconds
#
# Works on systems where the battery is BAT0, BAT1, etc.
# On desktops with no battery, it exits cleanly.
# ---------------------------------------------------------

# Find the first battery device
BATTERY=$(find /sys/class/power_supply/ -maxdepth 1 -type l \
    -exec sh -c '
        for device; do
            if [[ "$(cat "$device/type" 2>/dev/null)" == "Battery" ]]; then
                echo "$device"
                exit
            fi
        done
    ' sh {} +)

# Check whether a battery was found
if [[ -z "$BATTERY" ]]; then
    echo "No battery detected."
    echo "This system does not appear to have a battery."
    exit 0
fi

echo "Battery detected: $(basename "$BATTERY")"
echo

# ---------------------------------------------------------
# Ask whether to save a log
# ---------------------------------------------------------

read -rp "Save battery drain log? [y/N]: " save_log

if [[ "$save_log" =~ ^[Yy]$ ]]; then

    # Create a dedicated log directory
    LOG_DIR="$HOME/battery-logs"
    mkdir -p "$LOG_DIR"

    # Timestamp the log filename
    LOG_FILE="$LOG_DIR/battdrain_$(date '+%Y-%m-%d_%H-%M-%S').log"

    # Get initial battery percentage
    initial_capacity=$(cat "$BATTERY/capacity")

    {
        echo "========================================"
        echo "Battery Drain Log"
        echo "========================================"
        echo "Started: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Battery: $(basename "$BATTERY")"
        echo "Initial charge: ${initial_capacity}%"
        echo "========================================"
        echo
        echo "$(date '+%Y-%m-%d %H:%M:%S') | ${initial_capacity}%"
    } >> "$LOG_FILE"

    echo "Logging to: $LOG_FILE"
    echo

    # Determine the next 5% threshold.
    #
    # Example:
    #   Start at 87% -> next threshold is 85%
    #   Start at 84% -> next threshold is 80%
    #   Start at 63% -> next threshold is 60%
    next_threshold=$(( (initial_capacity / 5) * 5 ))

    if (( next_threshold >= initial_capacity )); then
        next_threshold=$((next_threshold - 5))
    fi

else
    LOG_FILE=""
    next_threshold=0
fi

# ---------------------------------------------------------
# Battery monitoring loop
# ---------------------------------------------------------

while true; do

    charge=$(cat "$BATTERY/charge_now")
    current=$(cat "$BATTERY/current_now")
    voltage=$(cat "$BATTERY/voltage_now")
    capacity=$(cat "$BATTERY/capacity")
    status=$(cat "$BATTERY/status")

    # Calculate power consumption.
    #
    # current_now is in microamps
    # voltage_now is in microvolts
    #
    # Dividing by 1,000,000,000,000 converts the result to watts.
    power=$(awk -v i="$current" -v v="$voltage" \
        'BEGIN { printf "%.2f", (i*v)/1000000000000 }')

    # Calculate estimated remaining time.
    if (( current > 0 )); then

        hours=$(awk -v c="$charge" -v i="$current" \
            'BEGIN { print c/i }')

        h=$(awk -v t="$hours" \
            'BEGIN { printf "%d", t }')

        m=$(awk -v t="$hours" \
            'BEGIN { printf "%d", (t*60)%60 }')

        remaining=$(printf "%02d:%02d" "$h" "$m")

    else
        remaining="--:--"
    fi

    # Display current status.
    printf "\r%s | %d%% | %.2f W | %s remaining   " \
        "$status" "$capacity" "$power" "$remaining"

    # -----------------------------------------------------
    # Log every 5% battery lost
    # -----------------------------------------------------

    if [[ -n "$LOG_FILE" ]] && (( capacity <= next_threshold )); then

        timestamp=$(date '+%Y-%m-%d %H:%M:%S')

        echo "$timestamp | ${capacity}% | ${power} W | ${status}" \
            >> "$LOG_FILE"

        # Move the threshold down another 5%.
        #
        # The while loop means that if the battery percentage
        # drops several thresholds between checks, we don't
        # get stuck on the old threshold.
        while (( capacity <= next_threshold )); do
            next_threshold=$((next_threshold - 5))
        done
    fi

    sleep 5
done
