#!/usr/bin/env bash
# pkg-export.sh - Export pacman + yay packages with optional ignore list
# Designed to be shared across Arch systems while skipping hardware-specific packages

set -euo pipefail

# ============================================================
# Configuration - edit these or override with flags
# ============================================================
OUTPUT_DIR="${OUTPUT_DIR:-./pkg-lists}"
IGNORE_PATTERNS=(
    # Graphics / GPU related (common across systems)
    "mesa"
    "nvidia"
    "amdgpu"
    "radeon"
    "intel-media"
    "intel-ucode"
    "xf86-video"
    "vulkan"
    "libva"
    "libvdpau"
    # Kernel / firmware that is often machine-specific
    "linux-firmware"
    "linux-headers"
    "linux-lts"
    "linux-zen"
    # Other frequently machine-specific packages (uncomment as needed)
    # "broadcom"
    # "realtek"
    # "nvidia-dkms"
)

# ============================================================
# Helper functions
# ============================================================
usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -o, --output DIR       Output directory (default: ./pkg-lists)
  -i, --ignore PATTERN   Additional ignore pattern (can be used multiple times)
  -c, --clear-ignore     Start with empty ignore list (ignore only what you pass with -i)
  -h, --help             Show this help

Examples:
  $(basename "$0")
  $(basename "$0") -i nvidia -i mesa -i amd
  $(basename "$0") -c -i "nvidia*" -i "mesa*"
  OUTPUT_DIR=~/backup $(basename "$0")
EOF
}

should_ignore() {
    local pkg="$1"
    local pattern
    for pattern in "${IGNORE_PATTERNS[@]}"; do
        # Simple substring match (case-insensitive)
        if [[ "${pkg,,}" == *"${pattern,,}"* ]]; then
            return 0
        fi
    done
    return 1
}

# ============================================================
# Argument parsing
# ============================================================
while [[ $# -gt 0 ]]; do
    case "$1" in
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -i|--ignore)
            IGNORE_PATTERNS+=("$2")
            shift 2
            ;;
        -c|--clear-ignore)
            IGNORE_PATTERNS=()
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage
            exit 1
            ;;
    esac
done

# ============================================================
# Main logic
# ============================================================
mkdir -p "$OUTPUT_DIR"
timestamp=$(date +%Y%m%d_%H%M%S)
# Use uname -n (more portable than hostname)
host=$(uname -n 2>/dev/null || echo "unknown")

# Temporary files
tmp_all=$(mktemp)
tmp_official=$(mktemp)
tmp_aur=$(mktemp)
tmp_filtered_official=$(mktemp)
tmp_filtered_aur=$(mktemp)

cleanup() {
    rm -f "$tmp_all" "$tmp_official" "$tmp_aur" \
          "$tmp_filtered_official" "$tmp_filtered_aur"
}
trap cleanup EXIT

echo "Collecting packages..."

# All explicitly installed packages (native + foreign)
pacman -Qe --quiet | sort > "$tmp_all"

# Official repo packages (native)
pacman -Qen --quiet | sort > "$tmp_official"

# AUR / foreign packages
pacman -Qem --quiet | sort > "$tmp_aur"

# Filter out ignored packages
while IFS= read -r pkg; do
    if ! should_ignore "$pkg"; then
        echo "$pkg"
    fi
done < "$tmp_official" > "$tmp_filtered_official"

while IFS= read -r pkg; do
    if ! should_ignore "$pkg"; then
        echo "$pkg"
    fi
done < "$tmp_aur" > "$tmp_filtered_aur"

# ============================================================
# Generate output files
# ============================================================

# 1. Human-readable full list
list_file="$OUTPUT_DIR/packages_${host}_${timestamp}.txt"
{
    echo "# Package list exported from: $host"
    echo "# Date: $(date)"
    echo "# Ignored patterns: ${IGNORE_PATTERNS[*]:-none}"
    echo "#"
    echo "# Official packages: $(wc -l < "$tmp_filtered_official")"
    echo "# AUR packages:      $(wc -l < "$tmp_filtered_aur")"
    echo ""
    echo "===== OFFICIAL (pacman) ====="
    cat "$tmp_filtered_official"
    echo ""
    echo "===== AUR (yay) ====="
    cat "$tmp_filtered_aur"
} > "$list_file"

# 2. Installer script (ready to run on another machine)
installer="$OUTPUT_DIR/install_${host}_${timestamp}.sh"
{
    cat <<'HEADER'
#!/usr/bin/env bash
# Auto-generated package installer
# Run with: bash install_XXXX.sh
# Requires: pacman + yay (or paru)

set -euo pipefail

echo "=== Installing official packages ==="
HEADER

    if [[ -s "$tmp_filtered_official" ]]; then
        echo "sudo pacman -S --needed --noconfirm \\"
        # Pretty-print with line continuations
        awk 'NR>1{print prev " \\"} {prev=$0} END{print prev}' "$tmp_filtered_official"
    else
        echo "echo \"(no official packages to install)\""
    fi

    cat <<'AUR'
echo ""
echo "=== Installing AUR packages ==="
AUR

    if [[ -s "$tmp_filtered_aur" ]]; then
        echo "yay -S --needed --noconfirm \\"
        awk 'NR>1{print prev " \\"} {prev=$0} END{print prev}' "$tmp_filtered_aur"
    else
        echo "echo \"(no AUR packages to install)\""
    fi

    cat <<'FOOTER'

echo ""
echo "Done."
FOOTER
} > "$installer"
chmod +x "$installer"

# 3. Simple plain lists (useful for scripting)
cp "$tmp_filtered_official" "$OUTPUT_DIR/official_${host}_${timestamp}.txt"
cp "$tmp_filtered_aur"       "$OUTPUT_DIR/aur_${host}_${timestamp}.txt"

# ============================================================
# Summary
# ============================================================
echo ""
echo "Done."
echo "  Official packages kept : $(wc -l < "$tmp_filtered_official")"
echo "  AUR packages kept      : $(wc -l < "$tmp_filtered_aur")"
echo "  Ignored patterns       : ${IGNORE_PATTERNS[*]:-none}"
echo ""
echo "Files created in: $OUTPUT_DIR"
echo "  - $(basename "$list_file")          (human-readable list)"
echo "  - $(basename "$installer")          (installer script)"
echo "  - official_${host}_${timestamp}.txt"
echo "  - aur_${host}_${timestamp}.txt"