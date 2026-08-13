#!/bin/bash

THEME="$HOME/.local/share/icons/Breeze-OrangeFolders"
ORANGE="#ff6200"
BLUE="#3daee9"

# Source Breeze locations (tries both common paths)
SOURCES=(
  "/usr/share/icons/breeze"
  "/usr/share/icons/breeze-dark"
)

mkdir -p "$THEME"/{places,mimetypes}/{16,22,24,32,48,64,96,128,256}

for SRC in "${SOURCES[@]}"; do
  if [ -d "$SRC" ]; then
    echo "Using source: $SRC"

    # Copy all folder* icons from places and the inode-directory from mimetypes
    for size in 16 22 24 32 48 64 96 128 256; do
      # places
      if [ -d "$SRC/places/$size" ]; then
        find "$SRC/places/$size" -name 'folder*.svg' -exec cp {} "$THEME/places/$size/" \; 2>/dev/null
      fi
      # mimetypes (the generic folder)
      if [ -f "$SRC/mimetypes/$size/inode-directory.svg" ]; then
        cp "$SRC/mimetypes/$size/inode-directory.svg" "$THEME/mimetypes/$size/" 2>/dev/null
      fi
    done
  fi
done

# Recolor every SVG we just copied
find "$THEME" -name "*.svg" -type f | while read -r file; do
  # Replace the classic Breeze blue and also any ColorScheme-Accent/Highlight definitions
  sed -i \
    -e "s/$BLUE/$ORANGE/gI" \
    -e "s/#3daee9/$ORANGE/gI" \
    -e "s/color:#3daee9/color:$ORANGE/gI" \
    -e "s/ColorScheme-Accent/ColorScheme-Text/g" \
    -e "s/ColorScheme-Highlight/ColorScheme-Text/g" \
    "$file"
done

echo "Done! Theme created at $THEME"
