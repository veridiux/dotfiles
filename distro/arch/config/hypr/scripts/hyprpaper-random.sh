
#!/bin/bash
WALL_DIR="$HOME/.dotfiles/wallpapers/3840x2400"
WALL=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.jxl" \) | shuf -n 1)

hyprctl hyprpaper wallpaper ", $WALL, cover"
