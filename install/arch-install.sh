#!/bin/bash
set -e

echo "[*] Setting up dotfiles..."

# Ensure ~/.config exists
mkdir -p ~/.config

# Symlink configs
ln -sf ~/dotfiles/distro/arch/config/hypr ~/.config/hypr
ln -sf ~/dotfiles/distro/arch/config/waybar ~/.config/waybar
ln -sf ~/dotfiles/common/bashrc ~/.bashrc
ln -sf ~/dotfiles/wallpapers ~/.config/hypr/wallpapers

# Install custom scripts into ~/bin (or ~/.local/bin if you prefer)
mkdir -p ~/bin
ln -sf ~/dotfiles/scripts/* ~/bin/

# Install systemd services (user mode)
mkdir -p ~/.config/systemd/user
ln -sf ~/dotfiles/systemd/* ~/.config/systemd/user/

# Reload systemd to see new services
systemctl --user daemon-reload

echo "[*] Dotfiles installed!"
echo "[*] Remember to enable services manually, e.g.:"
echo "    systemctl --user enable --now power-profile.service"

