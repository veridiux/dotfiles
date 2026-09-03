#!/bin/bash
# Setup XDG applications.menu for KDE / Dolphin
# Run with: sudo bash setup-xdg-menu.sh

pacman -S archlinux-xdg-menu   

set -euo pipefail

echo "==> Creating XDG menu directory..."
mkdir -p /etc/xdg/menus

echo "==> Writing applications.menu..."
cat > /etc/xdg/menus/applications.menu << 'EOF'
<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
 "http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">

<Menu>
  <Name>Applications</Name>

  <AppDir>/usr/share/applications</AppDir>
  <AppDir>~/.local/share/applications</AppDir>

  <DefaultLayout inline="false" show_empty="false">
    <Merge type="all"/>
  </DefaultLayout>

  <Include>
    <All/>
  </Include>
</Menu>
EOF

echo "==> Creating KDE compatibility symlink..."
ln -sf /etc/xdg/menus/applications.menu /etc/xdg/menus/plasma-applications.menu

echo "==> Rebuilding KDE service cache..."
if command -v kbuildsycoca6 >/dev/null 2>&1; then
  kbuildsycoca6 --noincremental
elif command -v kbuildsycoca5 >/dev/null 2>&1; then
  kbuildsycoca5 --noincremental
else
  echo "Warning: kbuildsycoca5/6 not found. Skipping cache rebuild."
fi

echo "==> Restarting Dolphin..."
pkill dolphin 2>/dev/null || true
# Only launch Dolphin if a display is available and the user is interactive
if [[ -n "${DISPLAY:-}" ]] && command -v dolphin >/dev/null 2>&1; then
  dolphin &
fi

echo "Done."
