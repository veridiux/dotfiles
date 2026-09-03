#!/bin/bash
GPU_FILE="$HOME/.config/hypr/gpu_mode.conf"
TMP_FILE="/tmp/gpu_mode"

# Read current mode
CURRENT=$(cat "$TMP_FILE" 2>/dev/null || echo "Integrated")

# Cycle modes
case "$CURRENT" in
    "Integrated") NEXT="Hybrid"; COLOR="#f0c674";;
    "Hybrid") NEXT="Dedicated"; COLOR="#ff5555";;
    "Dedicated") NEXT="Integrated"; COLOR="#61afef";;
    *) NEXT="Integrated"; COLOR="#61afef";;
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
env = AQ_DRM_DEVICES,/dev/dri/card1:
EOL
        ;;
esac

# Save mode for reference
echo "$NEXT" > "$TMP_FILE"

# Output the logo with color
echo "<span color=\"$COLOR\"></span>"

