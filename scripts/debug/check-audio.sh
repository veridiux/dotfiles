#!/usr/bin/env bash

echo "=== Arch Linux Audio Diagnostic ==="

# Check required packages
echo -e "\n[ Packages Installed ]"
for pkg in pipewire pipewire-pulse wireplumber alsa-utils sof-firmware; do
    if pacman -Q $pkg &>/dev/null; then
        echo "✅ $pkg is installed"
    else
        echo "❌ $pkg is MISSING"
    fi
done

# Check services
echo -e "\n[ PipeWire & WirePlumber Services ]"
systemctl --user is-active pipewire.service &>/dev/null && echo "✅ pipewire running" || echo "❌ pipewire NOT running"
systemctl --user is-active wireplumber.service &>/dev/null && echo "✅ wireplumber running" || echo "❌ wireplumber NOT running"

# ALSA playback devices
echo -e "\n[ ALSA Devices (aplay -l) ]"
if command -v aplay &>/dev/null; then
    aplay -l || echo "❌ No ALSA devices found"
else
    echo "❌ alsa-utils not installed (no aplay)"
fi

# PipeWire sinks
echo -e "\n[ PipeWire Sinks (pactl list short sinks) ]"
if command -v pactl &>/dev/null; then
    pactl list short sinks || echo "❌ No sinks found"
else
    echo "❌ pactl not installed"
fi

# Default sink
echo -e "\n[ Default Sink ]"
if command -v pactl &>/dev/null; then
    DEFAULT_SINK=$(pactl get-default-sink 2>/dev/null)
    if [[ -n "$DEFAULT_SINK" ]]; then
        echo "✅ Default sink: $DEFAULT_SINK"
    else
        echo "❌ No default sink set"
    fi
fi

# Mixer check
echo -e "\n[ ALSA Mixer ]"
if command -v amixer &>/dev/null; then
    amixer sget Master 2>/dev/null | grep -E 'Mono:|Front Left:|Right:' || echo "⚠️  No Master control found (try 'alsamixer')"
else
    echo "❌ alsa-utils not installed (no amixer)"
fi

echo -e "\n=== End of Check ==="

