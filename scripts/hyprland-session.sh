#!/bin/bash

# ---------------------------------------------------------
# Hyprland / Steam Gaming Mode Session
# ---------------------------------------------------------
#
# Ly starts THIS script instead of Hyprland directly.
#
# Normal:
#   Wrapper -> Hyprland
#
# Gaming Mode:
#   Wrapper -> Hyprland exits
#           -> Gamescope + Steam
#           -> Steam exits
#           -> Hyprland starts again
# ---------------------------------------------------------

FLAG="$HOME/.cache/steam-gaming-mode"

mkdir -p "$HOME/.cache"

while true; do

    # Start normal desktop.
    start-hyprland

    # Was Hyprland intentionally exited for Steam Gaming Mode?
    if [[ -f "$FLAG" ]]; then
        rm -f "$FLAG"

        export LIBSEAT_BACKEND=logind

        gamescope \
            --backend drm \
            --prefer-vk-device 1002:150e \
            -e \
            -- steam -gamepadui

        # Steam/Gamescope exited.
        # Loop around and start Hyprland again.
        continue
    fi

    # Normal logout from Hyprland.
    # End the Ly session normally.
    break
done
