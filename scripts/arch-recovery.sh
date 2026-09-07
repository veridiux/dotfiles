#!/bin/bash
set -e

DISK="/dev/nvme3n1p2"
ESP="/dev/nvme3n1p1"

OPTS="noatime,compress=zstd:3,ssd,discard=async"

echo "==> Mounting root..."
mkdir -p /mnt
mount -o subvol=@,$OPTS "$DISK" /mnt

echo "==> Creating mount points..."
mkdir -p /mnt/{boot,home,var/log,var/cache/pacman/pkg,swap,.snapshots}

echo "==> Mounting Btrfs subvolumes..."
mount -o subvol=@home,$OPTS "$DISK" /mnt/home
mount -o subvol=@log,$OPTS "$DISK" /mnt/var/log
mount -o subvol=@pkg,$OPTS "$DISK" /mnt/var/cache/pacman/pkg
mount -o subvol=@snapshots,$OPTS "$DISK" /mnt/.snapshots

# Swap subvolume: no compression / CoW
mount -o subvol=@swap,noatime,nodatacow "$DISK" /mnt/swap

echo "==> Mounting ESP..."
mount "$ESP" /mnt/boot

echo
echo "==> Mounts:"
findmnt -R /mnt
echo
echo "==> Entering chroot..."

arch-chroot /mnt
