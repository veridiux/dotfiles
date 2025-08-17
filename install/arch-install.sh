#!/bin/bash

# Ensure .config exists
mkdir -p ~/.config

# Create symlinks (overwrite if already exist)
ln -sf ~/dotfiles/distro/arch/config/hypr ~/.config/hypr
ln -sf ~/dotfiles/distro/arch/config/waybar ~/.config/waybar

ln -sf ~/dotfiles/wallpapers ~/.config/hypr/wallpapers

echo "Symlinks created!"

