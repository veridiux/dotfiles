#!/bin/bash

set -e

# ---------------------------------------------------------
# Install yay
# ---------------------------------------------------------

if command -v yay &>/dev/null; then
    echo "yay is already installed. Skipping."
    exit 0
fi

echo "==> Installing prerequisites..."
sudo pacman -S --needed git base-devel

echo "==> Cloning yay..."
TMP_DIR=$(mktemp -d)

git clone https://aur.archlinux.org/yay.git "$TMP_DIR/yay"

echo "==> Building yay..."
cd "$TMP_DIR/yay"
makepkg -si --noconfirm

echo "==> Cleaning up..."
rm -rf "$TMP_DIR"

echo
echo "============================================================"
echo " yay installed successfully!"
echo "============================================================"
