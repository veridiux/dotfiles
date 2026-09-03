#!/bin/bash

set -e

# ---------------------------------------------------------
# Git + SSH Setup
# ---------------------------------------------------------

DOTFILES="$HOME/.dotfiles"

echo "==> Installing Git and OpenSSH..."
sudo pacman -S --needed git openssh

echo "==> Configuring Git..."
git config --global user.name "justin"
git config --global user.email "veridiux@gmail.com"
git config --global init.defaultBranch main

echo "==> Setting up ~/.dotfiles..."
if [[ ! -d "$DOTFILES/.git" ]]; then
    git -C "$DOTFILES" init
else
    echo "~/.dotfiles is already a Git repository. Skipping."
fi

echo "==> Setting up SSH key..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
    ssh-keygen -t ed25519 -C "$USER@$(hostname)" -f "$HOME/.ssh/id_ed25519"
else
    echo "SSH key already exists. Skipping."
fi

echo "==> Enabling SSH daemon..."
sudo systemctl enable --now sshd

echo
echo "============================================================"
echo " Git + SSH setup complete!"
echo "============================================================"
echo
echo "Git repository:"
echo "  $DOTFILES"
echo
echo "SSH public key:"
echo
cat "$HOME/.ssh/id_ed25519.pub"
echo
echo "============================================================"
