#!/bin/bash
TMP_FILE="/tmp/gpu_mode"

MODE=$(cat "$TMP_FILE" 2>/dev/null || echo "Integrated")

# Set color per mode
case "$MODE" in
    "Integrated") COLOR="#61afef";;
    "Hybrid") COLOR="#f0c674";;
    "Dedicated") COLOR="#ff5555";;
    *) COLOR="#ffffff";;
esac

echo "<span color=\"$COLOR\"></span>"

