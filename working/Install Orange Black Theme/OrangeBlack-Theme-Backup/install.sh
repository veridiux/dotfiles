#!/bin/bash

# Orange Black Theme Installer
# Place this script in the same folder as:
#   - OrangeBlack.colors
#   - Breeze-OrangeFolders/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Orange Black theme..."

# Create target directories
mkdir -p ~/.local/share/color-schemes
mkdir -p ~/.local/share/icons

# Install color scheme
if [ -f "$SCRIPT_DIR/OrangeBlack.colors" ]; then
    cp "$SCRIPT_DIR/OrangeBlack.colors" ~/.local/share/color-schemes/
    echo "✓ Color scheme installed"
else
    echo "✗ OrangeBlack.colors not found next to this script"
    exit 1
fi

# Install icon theme
if [ -d "$SCRIPT_DIR/Breeze-OrangeFolders" ]; then
    cp -r "$SCRIPT_DIR/Breeze-OrangeFolders" ~/.local/share/icons/
    echo "✓ Icon theme installed"
else
    echo "✗ Breeze-OrangeFolders folder not found next to this script"
    exit 1
fi

# Clear caches
rm -rf ~/.cache/icon-cache.kcache ~/.cache/thumbnails/* 2>/dev/null || true
echo "✓ Icon cache cleared"

echo ""
echo "Done!"
echo "Now go to System Settings → Appearance and select:"
echo "  • Colors  → Orange Black"
echo "  • Icons   → Breeze Orange Folders"
echo ""
echo "Then fully close and reopen Dolphin (or log out/in)."
