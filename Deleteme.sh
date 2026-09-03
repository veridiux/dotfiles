#!/bin/bash

set -e

DISK="/dev/nvme0n1"
EFI_PART="1"
LABEL="Limine"
LOADER='\EFI\limine\limine_x64.efi'

echo "==> Creating Limine UEFI boot entry..."

efibootmgr \
    --create \
    --disk "$DISK" \
    --part "$EFI_PART" \
    --label "$LABEL" \
    --loader "$LOADER" \
    --unicode

echo
echo "==> Current UEFI boot entries:"
efibootmgr -v
