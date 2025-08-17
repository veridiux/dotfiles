#!/bin/bash
GPU_FILE="$HOME/.config/hypr/gpu_mode.conf"
TMP_FILE="/tmp/gpu_mode"

BAR_HEIGHT=32

# Simple menu: narrow, top-aligned, appears on focused monitor
CHOICE=$(echo -e "Integrated\nHybrid\nDedicated" | wofi --show dmenu \
    --prompt "GPU Mode:" \
    --lines 3 \
    --width 20 \
    --yoffset $BAR_HEIGHT)

[[ -z "$CHOICE" ]] && exit 0

case "$CHOICE" in
    "Integrated")
        cat > "$GPU_FILE" <<EOL
# Integrated Only
env = GBM_BACKEND,intel
env = __GLX_VENDOR_LIBRARY_NAME,mesa
env = LIBVA_DRIVER_NAME,iHD
env = AQ_DRM_DEVICES,/dev/dri/card0:
EOL
        ;;
    "Hybrid")
        cat > "$GPU_FILE" <<EOL
# Hybrid Mode
env = GBM_BACKEND,drm
env = __GLX_VENDOR_LIBRARY_NAME,mesa
env = LIBVA_DRIVER_NAME,iHD
env = AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1
EOL
        ;;
    "Dedicated")
        cat > "$GPU_FILE" <<EOL
# NVIDIA Only
env = GBM_BACKEND,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = LIBVA_DRIVER_NAME,nvidia
env = AQ_DRM_DEVICES,/dev/dri/card1:
EOL
        ;;
esac

echo "$CHOICE" > "$TMP_FILE"

