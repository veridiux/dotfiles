#!/bin/bash

set -e

# ---------------------------------------------------------
# Network Shares
# ---------------------------------------------------------

SERVER="10.1.7.55"
BASE="/mnt/shares/skynet"
CREDENTIALS="/home/justin/.config/samba/share"

SHARES=(
    "backup"
    "cache"
    "emulation"
    "extra"
    "media-server"
)

OPTIONS="credentials=$CREDENTIALS,_netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=600,uid=1000,gid=1000,file_mode=0644,dir_mode=0755"

echo "==> Creating mount points..."

for SHARE in "${SHARES[@]}"; do
    sudo mkdir -p "$BASE/$SHARE"
done

echo "==> Updating /etc/fstab..."

for SHARE in "${SHARES[@]}"; do
    ENTRY="//$SERVER/$SHARE $BASE/$SHARE cifs $OPTIONS 0 0"

    if ! grep -Fqx "$ENTRY" /etc/fstab; then
        echo "$ENTRY" | sudo tee -a /etc/fstab > /dev/null
        echo "Added: $SHARE"
    else
        echo "Already exists: $SHARE"
    fi
done

echo "==> Reloading systemd..."
sudo systemctl daemon-reload

echo
echo "============================================================"
echo " Network shares configured!"
echo "============================================================"
