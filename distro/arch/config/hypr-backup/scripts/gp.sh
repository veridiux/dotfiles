#!/bin/bash
# gpu-mode-switcher-gui.sh
# GUI version for switching GPU modes (Integrated, Hybrid, NVIDIA)
# Only edits gpu_mode.conf, main env.conf stays intact

GPU_FILE="$HOME/.config/hypr/gpu_mode.conf"  # only GPU variables

# Backup current GPU file
cp "$GPU_FILE" "$GPU_FILE.bak"

# Show GUI dialog
choice=$(zenity --list --title="Select GPU Mode" \
    --text="Choose your GPU mode:" \
    --column="Mode" \
    "Integrated Only (Intel)" \
    "Hybrid Mode (Intel + NVIDIA offload)" \
    "NVIDIA Only" \
    --height=250 --width=350)

# Check if user canceled
if [[ -z "$choice" ]]; then
    zenity --info --text="No selection made. Exiting."
    exit 1
fi

# Write corresponding GPU mode
case "$choice" in
    "Integrated Only (Intel)")
        cat > "$GPU_FILE" <<EOL
# Integrated Only
env = GBM_BACKEND,intel
env = __GLX_VENDOR_LIBRARY_NAME,mesa
env = LIBVA_DRIVER_NAME,iHD
env = AQ_DRM_DEVICES,/dev/dri/card0:
EOL
        ;;
    "Hybrid Mode (Intel + NVIDIA offload)")
        cat > "$GPU_FILE" <<EOL
# Hybrid Mode
env = GBM_BACKEND,drm
env = __GLX_VENDOR_LIBRARY_NAME,mesa
env = LIBVA_DRIVER_NAME,iHD
env = AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1
EOL
        ;;
    "NVIDIA Only")
        cat > "$GPU_FILE" <<EOL
# NVIDIA Only
env = GBM_BACKEND,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = LIBVA_DRIVER_NAME,nvidia
env = AQ_DRM_DEVICES,/dev/dri/card1:
EOL
        ;;
esac

zenity --info --text="GPU mode set to $choice.\nLog out and start your Wayland session for changes to take effect."

