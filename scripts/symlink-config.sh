#!/usr/bin/env bash
set -euo pipefail

SOURCE="$HOME/.dotfiles/distro/arch/config"
TARGET="$HOME/.config"

mkdir -p "$TARGET"

for item in "$SOURCE"/*; do
    name="$(basename "$item")"
    dest="$TARGET/$name"

    if [[ -e "$dest" || -L "$dest" ]]; then
        echo "Backing up $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    echo "Linking $item -> $dest"
    ln -s "$item" "$dest"
done

echo "Done!"
