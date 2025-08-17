#!/bin/bash
GPU_FILE="$HOME/.config/hypr/source/gpu_mode.conf"
TMP_FILE="/tmp/gpu_mode"

CURRENT=$(cat "$TMP_FILE" 2>/dev/null || echo "Integrated")

# Cycle through modes
case "$CURRENT" in
    "Integrated") NEXT="Hybrid";;
    "Hybrid") NEXT="Dedicated";;
    "Dedicated") NEXT="Integrated";;
    *) NEXT="Integrated";;
esac

# Update GPU config
case "$NEXT" in
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
env = AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0
EOL
        ;;
esac

echo "$NEXT" > "$TMP_FILE"

