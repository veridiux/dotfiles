#!/bin/bash

FLAG="$HOME/.cache/steam-gaming-mode"

mkdir -p "$HOME/.cache"
touch "$FLAG"

# Shut down Steam running inside Hyprland.
steam -shutdown 2>/dev/null || true

# Wait up to ~10 seconds for Steam to actually exit.
for _ in {1..20}; do
    pgrep -x steam >/dev/null || break
    sleep 0.5
done

# Exit Hyprland using the Hyprland 0.55+ Lua dispatcher API.
hyprctl dispatch 'hl.dsp.exit()'
