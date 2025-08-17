#!/bin/bash
# AC / NVIDIA Only

GPU_FILE="/home/justin/.config/hypr/source/gpu_mode.conf"

# Write the config for persistence / future reference
cat > "$GPU_FILE" <<EOL
# NVIDIA Only
env = GBM_BACKEND,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = LIBVA_DRIVER_NAME,nvidia
env = AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0
EOL

# Export variables for current session
export GBM_BACKEND=nvidia
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export LIBVA_DRIVER_NAME=nvidia
export AQ_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0

# Give Hyprland a moment to start (optional safety)
sleep 3

# Reload Hyprland so it sees the new GPU env
hyprctl dispatch restart


brightnessctl -d intel_backlight set 100%

# Log
logger "Power-profile: AC mode - NVIDIA only applied"


