#!/bin/bash
# Combined: hide/show Waybar for Steam Big Picture + games
# and return to Big Picture's workspace when the last game closes

export PATH="/usr/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

SOCKET=$(find "$XDG_RUNTIME_DIR/hypr" -name ".socket2.sock" | head -n1)
declare -A STEAM_GAMES

LOG="$HOME/.cache/steam-swd.log"
exec >>"$LOG" 2>&1
echo "=== steam-swd started $(date) ==="

# Give the normal Waybar startup a moment to finish
sleep 5

# Assume Waybar is already running (your hyprland exec-once handles it)
WAYBAR_RUNNING=1
if ! pgrep -x waybar >/dev/null; then
    WAYBAR_RUNNING=0
fi

should_hide_waybar() {
    if hyprctl clients -j 2>/dev/null | jq -e '
        .[] | select(.title == "Steam Big Picture Mode")
    ' >/dev/null; then
        return 0
    fi

    if hyprctl clients -j 2>/dev/null | jq -e '
        .[] | select(.class | test("^(steam_app_|gamescope|wine|Wine|.*\\.exe)$"))
    ' >/dev/null; then
        return 0
    fi

    return 1
}

update_waybar() {
    if should_hide_waybar; then
        if [[ $WAYBAR_RUNNING -eq 1 ]]; then
            echo "$(date): Steam UI/game active → killing waybar"
            killall -9 waybar 2>/dev/null
            WAYBAR_RUNNING=0
        fi
    else
        if [[ $WAYBAR_RUNNING -eq 0 ]]; then
            echo "$(date): no Steam UI/game → starting waybar"
            nohup /usr/bin/waybar >/dev/null 2>&1 &
            sleep 0.4
            if pgrep -x waybar >/dev/null; then
                WAYBAR_RUNNING=1
                echo "$(date): waybar started (PID $(pgrep -x waybar))"
            else
                echo "$(date): ERROR – waybar failed to start"
            fi
        fi
    fi
}

# Do NOT call update_waybar here on startup
# We only react to events from now on

socat -U - UNIX-CONNECT:"$SOCKET" | while read -r event; do
    case "$event" in
        openwindow*)
            DATA="${event#*>>}"
            ADDRESS=$(echo "$DATA" | cut -d',' -f1)
            CLASS=$(echo "$DATA" | cut -d',' -f3)

            if [[ "$CLASS" =~ steam_app_ ]]; then
                STEAM_GAMES["$ADDRESS"]=1
                echo "$(date): tracked game $CLASS ($ADDRESS)"
            fi

            update_waybar
            ;;

        closewindow*)
            ADDRESS="${event#*>>}"

            if [[ "${STEAM_GAMES[$ADDRESS]}" == "1" ]]; then
                echo "$(date): game closed ($ADDRESS)"
                unset STEAM_GAMES["$ADDRESS"]
                sleep 1.0

                HAS_WINDOWS_ON_5=$(hyprctl clients -j | jq '[.[] | select(.workspace.id == 5)] | length')

                if [[ "$HAS_WINDOWS_ON_5" -eq 0 ]]; then
                    BPM_WS=$(hyprctl clients -j | jq -r '
                        .[] | select(.title == "Steam Big Picture Mode" or .title =="Steam") | .workspace.id
                    ' | head -n1)

                    if [[ -n "$BPM_WS" && "$BPM_WS" != "null" ]]; then
                        echo "$(date): switching to Big Picture on workspace $BPM_WS"
                        hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = \"$BPM_WS\" }))"
                    else
                        echo "$(date): Big Picture not found"
                    fi
                fi
            fi

            update_waybar
            ;;

        windowtitle*|activewindow*)
            update_waybar
            ;;
    esac
done
