#!/usr/bin/env bash

set -euo pipefail

OUTDIR="$HOME/.dotfiles/packages/auto"

mkdir -p "$OUTDIR"

echo "Exporting package lists..."

# Official repository packages
pacman -Qqe | pacman -Qqm | sort > /tmp/aur.tmp
pacman -Qqe | sort > /tmp/all.tmp
comm -23 /tmp/all.tmp /tmp/aur.tmp > "$OUTDIR/pacman-packages.txt"

# AUR packages
grep -vx "yay" /tmp/aur.tmp > "$OUTDIR/aur-packages.txt"

rm /tmp/all.tmp /tmp/aur.tmp

cat > "$OUTDIR/reinstall.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing official packages..."
sudo pacman -S --needed - < "$DIR/pacman-packages.txt"

if command -v yay >/dev/null; then
    echo "Installing AUR packages..."
    yay -S --needed --answerclean None --answerdiff None $(cat "$DIR/aur-packages.txt")
else
    echo
    echo "============================================="
    echo "Install yay first, then run this script again."
    echo "============================================="
fi
EOF

chmod +x "$OUTDIR/reinstall.sh"

echo
echo "Done!"
echo
echo "Files created:"
echo "  $OUTDIR/pacman-packages.txt"
echo "  $OUTDIR/aur-packages.txt"
echo "  $OUTDIR/reinstall.sh"
