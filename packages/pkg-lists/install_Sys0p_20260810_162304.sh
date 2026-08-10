#!/usr/bin/env bash
# Auto-generated package installer
# Run with: bash install_XXXX.sh
# Requires: pacman + yay (or paru)

set -euo pipefail

echo "=== Installing official packages ==="
sudo pacman -S --needed --noconfirm \
base \
base-devel \
bluez-utils \
breeze \
btrfs-progs \
cups \
cups-pk-helper \
discord \
dkms \
dolphin \
dunst \
efibootmgr \
fastfetch \
fuzzel \
gamescope \
ghostscript \
gimp \
git \
gnome-themes-extra \
godot \
grim \
gst-plugin-pipewire \
htop \
hypridle \
hyprland \
hyprlock \
hyprpaper \
jq \
kdenlive \
kitty \
libreoffice-fresh \
limine \
linux \
lvm2 \
ly \
man-db \
mkinitcpio \
mpv \
nano \
neovim \
networkmanager \
nm-connection-editor \
obs-studio \
openrazer-daemon \
openrazer-driver-dkms \
pavucontrol \
pipewire-alsa \
pipewire-jack \
pipewire-pulse \
polkit-kde-agent \
power-profiles-daemon \
python-openrazer \
qalculate-gtk \
qt5-wayland \
qt6-wayland \
quickshell \
rofi \
rustup \
slurp \
smartmontools \
snap-pac \
snapper \
socat \
sof-firmware \
steam \
sudo \
system-config-printer \
tree \
ttf-jetbrains-mono-nerd \
ttf-nerd-fonts-symbols \
uwsm \
vim \
wget \
wireplumber \
wofi \
wpa_supplicant \
xdg-desktop-portal-hyprland \
xdg-utils \
yazi \
zram-generator \
zsh \
zsh-autosuggestions \
zsh-syntax-highlighting
echo ""
echo "=== Installing AUR packages ==="
yay -S --needed --noconfirm \
blueberry \
brave-bin \
iris-colors \
limine-entry-tool \
polychromatic \
vscodium-bin \
yay \
yay-debug

echo ""
echo "Done."
