#!/bin/bash
# ~/bin/hyprland_launcher.sh
# Double-launch "warm-up" wrapper for Hyprland

set -Eeuo pipefail

# How long to let the warm-up run before restarting (override with WARMUP_DELAY=1.5)
WARMUP_DELAY="${WARMUP_DELAY:-2}"

# Optional GPU mode selection
# [ -x /usr/local/bin/select_gpu_mode.sh ] && /usr/local/bin/select_gpu_mode.sh || true

kill_helpers() {
  # Try exact-name kill first, then fall back to pattern if needed
  for p in waybar hyprpaper hypridle; do
    pkill -x -TERM "$p" 2>/dev/null || pkill -f -TERM "$p" 2>/dev/null || true
  done
  # Give them a moment to exit, then hard-kill leftovers
  sleep 0.3
  for p in waybar hyprpaper hypridle; do
    pkill -x -KILL "$p" 2>/dev/null || pkill -f -KILL "$p" 2>/dev/null || true
  done
}

# Start warm-up Hyprland
Hyprland & HYPR_PID=$!

# Ensure the warm-up Hyprland is cleaned up if the script is interrupted
cleanup() { kill -TERM "$HYPR_PID" 2>/dev/null || true; }
trap cleanup INT TERM EXIT

# Let AC/Battery scripts and exec-once stuff run
sleep "$WARMUP_DELAY"

# Stop helpers first (avoid duplicates), then terminate warm-up Hyprland
kill_helpers
kill -TERM "$HYPR_PID" 2>/dev/null || true

# Wait up to ~3s for it to die, then force if needed (GNU coreutils)
timeout 3s tail --pid="$HYPR_PID" -f /dev/null 2>/dev/null || kill -KILL "$HYPR_PID" 2>/dev/null || true
wait "$HYPR_PID" 2>/dev/null || true

# Disarm trap before final exec
trap - INT TERM EXIT

# Final run
exec Hyprland

