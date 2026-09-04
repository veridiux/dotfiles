
#!/bin/bash

set -e

ROOT="/dev/nvme0n1p2"
EFI="/dev/nvme0n1p1"
MNT="/mnt"

mount -o subvol=@ "$ROOT" "$MNT"
mount --mkdir -o subvol=@home "$ROOT" "$MNT/home"
mount --mkdir -o subvol=@log "$ROOT" "$MNT/var/log"
mount --mkdir -o subvol=@pkg "$ROOT" "$MNT/var/cache/pacman/pkg"
mount --mkdir -o subvol=@swap "$ROOT" "$MNT/swap"
mount --mkdir -o subvol=@snapshots "$ROOT" "$MNT/.snapshots"
mount --mkdir "$EFI" "$MNT/efi"

echo "All filesystems mounted successfully."
findmnt -R "$MNT"

