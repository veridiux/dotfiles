#!/usr/bin/env bash

set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing official packages..."
sudo pacman -S --needed - < "$DIR/pacman-packages.txt"

if command -v yay >/dev/null; then
    echo "Installing AUR packages..."
    yay -S --needed --answerclean None --answerdiff None $(cat "$DIR/aur-packages.txt")
else
    echo
    echo "============================================="
    echo "Install yay first, then run this script again."
    echo "============================================="
fi
