#!/usr/bin/env bash
# arch-package-backup.sh
# Saves explicitly installed pacman + yay (AUR) packages for easy reinstall

# How to use
#./arch-package-backup.sh
# or
#./arch-package-backup.sh ~/my-packages

# Reinstall
#sudo pacman -S --needed - < official-packages.txt
#yay -S --needed - < aur-packages.txt



set -euo pipefail

BACKUP_DIR="${1:-./package-backup}"
mkdir -p "$BACKUP_DIR"

OFFICIAL="$BACKUP_DIR/official-packages.txt"
AUR="$BACKUP_DIR/aur-packages.txt"
ALL_EXPLICIT="$BACKUP_DIR/all-explicit.txt"
FULL="$BACKUP_DIR/all-packages-including-deps.txt"

echo "=== Arch Package Backup ==="
echo "Backup directory: $BACKUP_DIR"
echo

# Explicitly installed packages (what you actually wanted)
pacman -Qqe > "$ALL_EXPLICIT"

# Official repo packages (native)
pacman -Qqen > "$OFFICIAL"

# AUR / foreign packages (usually installed by yay)
pacman -Qqem > "$AUR"

# Everything currently installed (including dependencies) – optional
pacman -Qq > "$FULL"

echo "Official packages:  $(wc -l < "$OFFICIAL")"
echo "AUR packages:       $(wc -l < "$AUR")"
echo "Total explicit:     $(wc -l < "$ALL_EXPLICIT")"
echo "Total installed:    $(wc -l < "$FULL")"
echo

echo "Files created:"
ls -1 "$BACKUP_DIR"
echo

# Pretty print
echo "── Official packages ──"
cat "$OFFICIAL"
echo
echo "── AUR packages ──"
cat "$AUR"
