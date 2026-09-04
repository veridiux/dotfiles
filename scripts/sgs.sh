#!/bin/bash

# ---------------------------------------------------------
# Steam Gaming Mode
# ---------------------------------------------------------
# Launch Steam Gamepad UI in a standalone Gamescope session.
#
# AMD Radeon 880M / 890M:
#   PCI:       0000:65:00.0
#   PCI ID:    1002:150e
#   DRM card:  /dev/dri/card1
#
# Run from a TTY with Hyprland stopped/logged out.
# ---------------------------------------------------------

echo "Starting Steam Gaming Mode..."

exec gamescope \
    --backend drm \
    --prefer-vk-device 1002:150e \
    -e \
    -- steam -gamepadui
