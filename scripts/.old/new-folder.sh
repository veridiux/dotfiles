#!/bin/bash

THEME="$HOME/.local/share/icons/Breeze-OrangeFolders"
ORANGE="#ff6200"
BLUE="#3daee9"

# Clean previous attempt
rm -rf "$THEME"/{places,mimetypes}
mkdir -p "$THEME"/{places,mimetypes}/{16,22,24,32,48,64,96,128,256}

# Find Breeze source
SRC=""
for candidate in /usr/share/icons/breeze /usr/share/icons/breeze-dark; do
  if [ -d "$candidate" ]; then
    SRC="$candidate"
    break
  fi
done

if [ -z "$SRC" ]; then
  echo "Could not find Breeze icons. Aborting."
  exit 1
fi

echo "Using source: $SRC"

# Copy folder icons
for size in 16 22 24 32 48 64 96 128 256; do
  # places
  if [ -d "$SRC/places/$size" ]; then
    find "$SRC/places/$size" -name 'folder*.svg' -exec cp -t "$THEME/places/$size/" {} + 2>/dev/null
  fi
  # generic folder
  if [ -f "$SRC/mimetypes/$size/inode-directory.svg" ]; then
    cp "$SRC/mimetypes/$size/inode-directory.svg" "$THEME/mimetypes/$size/" 2>/dev/null
  fi
done

# Safer recoloring – only replace the blue color values
find "$THEME" -name "*.svg" -type f | while read -r file; do
  sed -i \
    -e "s/$BLUE/$ORANGE/gI" \
    -e "s/#3daee9/$ORANGE/gI" \
    -e "s/color:#3daee9/color:$ORANGE/gI" \
    -e "s/color: #3daee9/color: $ORANGE/gI" \
    "$file"
done

echo "Done. Now switch to the theme and clear cache."
