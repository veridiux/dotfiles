#!/bin/bash

set -e

# ---------------------------------------------------------
# Zsh Setup
# ---------------------------------------------------------

ZSHRC="$HOME/.zshrc"
DOTFILES_ZSHRC="$HOME/.dotfiles/shells/.zshrc"
ZSH="/bin/zsh"

echo "==> Installing Zsh and plugins..."
yay -S --needed zsh zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete

echo "==> Setting up .zshrc..."

if [[ -e "$ZSHRC" || -L "$ZSHRC" ]]; then
    if [[ "$(readlink -f "$ZSHRC")" != "$DOTFILES_ZSHRC" ]]; then
        mv "$ZSHRC" "$ZSHRC.backup"
        echo "Backed up existing .zshrc to .zshrc.backup"
    fi
fi

if [[ ! -L "$ZSHRC" ]]; then
    ln -s "$DOTFILES_ZSHRC" "$ZSHRC"
fi

echo "==> Checking default shell..."

CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"

if [[ "$CURRENT_SHELL" != "$ZSH" ]]; then
    chsh -s "$ZSH"
    echo "Default shell changed to $ZSH"
else
    echo "Zsh is already the default shell. Skipping."
fi

echo
echo "============================================================"
echo " Zsh setup complete!"
echo "============================================================"
echo
echo "Zsh:        $ZSH"
echo ".zshrc:     $ZSHRC -> $DOTFILES_ZSHRC"
echo "Login shell: $(getent passwd "$USER" | cut -d: -f7)"
echo
echo "Log out and back in if the shell was just changed."
echo "============================================================"
