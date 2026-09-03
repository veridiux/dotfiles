#!/usr/bin/env bash
INTERVAL=1

# Helper: human-readable bytes
human() {
    local bytes=$1
    if (( bytes >= 1073741824 )); then
        printf "%.1fG" "$(echo "scale=1; $bytes/1073741824" | bc)"
    elif (( bytes >= 1048576 )); then
        printf "%.1fM" "$(echo "scale=1; $bytes/1048576" | bc)"
    elif (( bytes >= 1024 )); then
        printf "%.1fK" "$(echo "scale=1; $bytes/1024" | bc)"
    else
        printf "%dB" "$bytes"
    fi
}

# Detect GPUs once
detect_gpus() {
    GPU_INFO=()
    # NVIDIA
    if command -v nvidia-smi &>/dev/null; then
        while IFS= read -r line; do
            GPU_INFO+=("NVIDIA: $line")
        done < <(nvidia-smi --query-gpu=name,pci.bus_id --format=csv,noheader 2>/dev/null)
    fi
    # AMD / Intel via DRM
    for card in /sys/class/drm/card[0-9]; do
        [[ -e "$card/device/vendor" ]] || continue
        vendor=$(cat "$card/device/vendor" 2>/dev/null)
        name=$(cat "$card/device/uevent" 2>/dev/null | grep -oP 'PCI_ID=\K.*' || echo "unknown")
        driver=$(basename "$(readlink -f "$card/device/driver" 2>/dev/null)" 2>/dev/null || echo "?")
        case "$vendor" in
            0x10de) ;; # already covered by nvidia-smi
            0x1002) GPU_INFO+=("AMD ($driver): $name") ;;
            0x8086) GPU_INFO+=("Intel ($driver): $name") ;;
            *)      GPU_INFO+=("Other ($driver): $name") ;;
        esac
    done
}

# GPU utilization + type for a given PID
show_gpu() {
    local pid=$1
    echo "GPU:"
    if [[ ${#GPU_INFO[@]} -eq 0 ]]; then
        echo "  No GPU detected (or tools missing)"
        return
    fi

    # Print detected GPUs
    for g in "${GPU_INFO[@]}"; do
        echo "  Detected: $g"
    done
    echo

    # --- NVIDIA ---
    if command -v nvidia-smi &>/dev/null; then
        # System-wide util
        util=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,name --format=csv,noheader,nounits 2>/dev/null)
        echo "  NVIDIA system load:"
        while IFS=',' read -r u mem_used mem_total name; do
            echo "    $name → ${u}%  VRAM ${mem_used}/${mem_total} MiB"
        done <<< "$util"

        # Is our PID using it?
        if nvidia-smi --query-compute-apps=pid --format=csv,noheader 2>/dev/null | grep -qw "$pid" || \
           nvidia-smi pmon -c 1 2>/dev/null | awk -v p="$pid" '$2==p {found=1} END{exit !found}'; then
            echo "  → Waybar (PID $pid) appears on NVIDIA (dedicated)"
        else
            # Check open devices
            if lsof -p "$pid" 2>/dev/null | grep -qE '/dev/nvidia|/dev/dri/card'; then
                echo "  → Waybar has open NVIDIA/DRI devices (likely dedicated or hybrid)"
            else
                echo "  → Waybar not listed on NVIDIA compute/graphics apps"
            fi
        fi
    fi

    # --- AMD (sysfs) ---
    for busy in /sys/class/drm/card*/device/gpu_busy_percent; do
        [[ -r "$busy" ]] || continue
        pct=$(cat "$busy" 2>/dev/null)
        card=$(echo "$busy" | grep -oP 'card\d+')
        echo "  AMD $card load: ${pct}%"
    done

    # --- Intel ---
    if command -v intel_gpu_top &>/dev/null; then
        # One-shot sample (quiet)
        echo "  Intel GPU (intel_gpu_top sample):"
        timeout 0.8 intel_gpu_top -o - -s 100 2>/dev/null | head -20 || echo "    (could not sample)"
    fi

    # Heuristic: dedicated vs onboard based on open devices + known discrete vendors
    echo
    if lsof -p "$pid" 2>/dev/null | grep -qE '/dev/nvidia[0-9]'; then
        echo "  Verdict: using dedicated NVIDIA GPU"
    elif lsof -p "$pid" 2>/dev/null | grep -qE '/dev/dri/renderD|/dev/dri/card'; then
        # Check if any discrete AMD/NVIDIA is present
        if lspci 2>/dev/null | grep -qiE 'VGA.*(NVIDIA|AMD|ATI).*\['; then
            # crude: if discrete exists and process has DRI, often the discrete one when offloaded
            echo "  Verdict: using DRI (could be integrated or dedicated – check compositor)"
        else
            echo "  Verdict: using onboard / integrated GPU (DRI)"
        fi
    else
        echo "  Verdict: no GPU devices open by Waybar (software rendering or compositor owns GPU)"
    fi
}

# Network: system rates + process sockets
show_net() {
    local pid=$1
    echo "Network:"

    # System interface rates (simple delta)
    declare -A prev_rx prev_tx
    if [[ -f /tmp/waybar_mon_net ]]; then
        source /tmp/waybar_mon_net
    fi

    echo "  Interfaces (RX / TX rate):"
    while read -r iface rx tx; do
        [[ "$iface" == "lo:" ]] && continue
        rx=${rx%:}  # strip colon if present
        if [[ -n "${prev_rx[$iface]}" ]]; then
            drx=$(( (rx - prev_rx[$iface]) / INTERVAL ))
            dtx=$(( (tx - prev_tx[$iface]) / INTERVAL ))
            printf "    %-10s  ↓ %s/s   ↑ %s/s\n" "$iface" "$(human $drx)" "$(human $dtx)"
        else
            printf "    %-10s  (collecting…)\n" "$iface"
        fi
        prev_rx[$iface]=$rx
        prev_tx[$iface]=$tx
    done < <(awk 'NR>2 {print $1, $2, $10}' /proc/net/dev)

    # Save for next iteration
    {
        echo "declare -A prev_rx prev_tx"
        for i in "${!prev_rx[@]}"; do
            echo "prev_rx[$i]=${prev_rx[$i]}"
            echo "prev_tx[$i]=${prev_tx[$i]}"
        done
    } > /tmp/waybar_mon_net

    # Process sockets
    echo
    echo "  Waybar sockets (PID $pid):"
    local found=0
    for fd in /proc/"$pid"/fd/*; do
        link=$(readlink "$fd" 2>/dev/null)
        if [[ "$link" =~ socket:\[([0-9]+)\] ]]; then
            ino=${BASH_REMATCH[1]}
            ss -ltnpH "sport = :*" 2>/dev/null | grep -q "pid=$pid" && found=1
            ss -tnpH 2>/dev/null | grep "pid=$pid" | head -5
            found=1
        fi
    done
    if [[ $found -eq 0 ]]; then
        # fallback
        ss -tnp 2>/dev/null | grep "pid=$pid" | head -5 || echo "    (no TCP sockets or insufficient perms)"
    fi
}

# ---------- main loop ----------
detect_gpus

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
    ps -p "$ID_PID" -o %cpu,%mem,rss,cmd --no-headers
    echo

    echo "Threads:"
    ps -o nlwp= -p "$ID_PID"
    echo

    echo "Memory:"
    grep -E 'VmRSS|VmSize' /proc/"$ID_PID"/status
    echo

    show_gpu "$ID_PID"
    echo

    show_net "$ID_PID"

    sleep "$INTERVAL"
done
