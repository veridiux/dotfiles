#!/bin/bash
# /usr/local/bin/hypr_intel.sh
# Copy Intel GPU config to active gpu_mode.conf

GPU_OPTIONS_DIR="/home/justin/.config/hypr/source/gpu_options"
ACTIVE_CONF="/home/justin/.config/hypr/source/gpu_mode.conf"

cp -f "$GPU_OPTIONS_DIR/gpu_intel.conf" "$ACTIVE_CONF"
echo "GPU mode set to INTEL"

