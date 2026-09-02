#!/bin/bash

set -e

echo "=========================================="
echo " Arch Linux Recovery / Chroot"
echo "=========================================="
echo

echo "[1/5] Activating LVM..."
vgchange -ay

echo
echo "[2/5] Mounting root..."
mount -o subvol=@ /dev/ArchinstallVg/root /mnt

echo
echo "[3/5] Mounting EFI/boot..."
mount /dev/nvme0n1p1 /mnt/boot

echo
echo "[4/5] Mounting virtual filesystems..."

mount --types proc /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --rbind /dev /mnt/dev
mount --rbind /run /mnt/run

mount --make-rslave /mnt/sys
mount --make-rslave /mnt/dev
mount --make-rslave /mnt/run

echo
echo "=========================================="
echo " Mounts ready"
echo "=========================================="
echo
echo "Root:"
findmnt /mnt
echo
echo "Boot:"
findmnt /mnt/boot
echo
echo "EFI/Kernel files:"
ls -lh /mnt/boot/EFI/Linux/ 2>/dev/null || true
echo

echo "[5/5] Entering installed system..."
echo

arch-chroot /mnt
