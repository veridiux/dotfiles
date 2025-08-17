#!/bin/bash
# Battery / Integrated GPU Only

GPU_FILE="/home/justin/.config/hypr/source/gpu_mode.conf"

cat > "$GPU_FILE" <<EOL
# Integrated Only
env = GBM_BACKEND,intel
env = __GLX_VENDOR_LIBRARY_NAME,mesa
env = LIBVA_DRIVER_NAME,iHD
env = AQ_DRM_DEVICES,/dev/dri/card0:
EOL

# Export only the necessary variables
export GBM_BACKEND=intel
export __GLX_VENDOR_LIBRARY_NAME=mesa
export LIBVA_DRIVER_NAME=iHD
export AQ_DRM_DEVICES=/dev/dri/card0:

# Log
logger "Power-profile: Battery mode - Integrated GPU applied"

brightnessctl -d intel_backlight set 35%
