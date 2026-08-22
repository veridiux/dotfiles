#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_DIR="$HOME/.ssh"

case "$1" in
    backup)
        cp "$SSH_DIR/id_ed25519" "$SCRIPT_DIR/"
        cp "$SSH_DIR/id_ed25519.pub" "$SCRIPT_DIR/"
        echo "SSH keys backed up to:"
        echo "$SCRIPT_DIR"
        ;;

    restore)
        cp "$SCRIPT_DIR/id_ed25519" "$SSH_DIR/"
        cp "$SCRIPT_DIR/id_ed25519.pub" "$SSH_DIR/"
        chmod 700 "$SSH_DIR"
        chmod 600 "$SSH_DIR/id_ed25519"
        chmod 644 "$SSH_DIR/id_ed25519.pub"
        echo "SSH keys restored."
        ;;

    *)
        echo "Usage: $0 {backup|restore}"
        ;;
esac
