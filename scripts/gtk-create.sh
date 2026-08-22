#!/usr/bin/env bash

set -euo pipefail

# ============================================================
#  Create a custom GTK theme (light or dark) with custom accent
# ============================================================

usage() {
    cat <<EOF
Usage: $0 <ThemeName> <light|dark> <#RRGGBB>

Examples:
  $0 MyBlue light  #3584e4
  $0 Midnight dark #cba6f7
  $0 Coral  light  #ff6b6b

The theme will be installed to: ~/.themes/<ThemeName>/
EOF
    exit 1
}

# --- Argument checks ---
[[ $# -eq 3 ]] || usage

NAME="$1"
MODE="$2"
ACCENT="$3"

# Validate mode
if [[ "$MODE" != "light" && "$MODE" != "dark" ]]; then
    echo "Error: mode must be 'light' or 'dark'"
    exit 1
fi

# Validate hex color (#RRGGBB)
if [[ ! "$ACCENT" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
    echo "Error: accent color must be a 6-digit hex value, e.g. #3584e4"
    exit 1
fi

# --- Helper: calculate relative luminance to decide text color on accent ---
is_light_color() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    # Perceived luminance (simplified)
    local luma=$(( (r * 299 + g * 587 + b * 114) / 1000 ))
    (( luma > 160 ))
}

if is_light_color "$ACCENT"; then
    ACCENT_FG="#1a1a1a"   # dark text on light accent
else
    ACCENT_FG="#ffffff"   # white text on dark accent
fi

# --- Base colors depending on light/dark ---
if [[ "$MODE" == "light" ]]; then
    BG_COLOR="#fafafa"
    FG_COLOR="#2e3436"
    BASE_COLOR="#ffffff"
    VIEW_BG="#ffffff"
    HEADER_BG="#f0f0f0"
    BORDERS="#c0c0c0"
    SELECTED_BG="$ACCENT"
else
    BG_COLOR="#242424"
    FG_COLOR="#eeeeec"
    BASE_COLOR="#1e1e1e"
    VIEW_BG="#1e1e1e"
    HEADER_BG="#2d2d2d"
    BORDERS="#3d3d3d"
    SELECTED_BG="$ACCENT"
fi

THEME_DIR="$HOME/.themes/$NAME"

echo "Creating theme: $NAME ($MODE) with accent $ACCENT"
echo "→ $THEME_DIR"

# Create directory structure
mkdir -p "$THEME_DIR/gtk-3.0" "$THEME_DIR/gtk-4.0"

# ------------------------------------------------------------
# index.theme
# ------------------------------------------------------------
cat > "$THEME_DIR/index.theme" <<EOF
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=$NAME
Comment=Custom $MODE theme – accent $ACCENT
Encoding=UTF-8

[X-GNOME-Metatheme]
GtkTheme=$NAME
MetacityTheme=$NAME
IconTheme=Adwaita
CursorTheme=Adwaita
ButtonLayout=close,minimize,maximize:
EOF

# ------------------------------------------------------------
# Shared CSS content (works for both GTK3 and GTK4)
# ------------------------------------------------------------
CSS_CONTENT=$(cat <<EOF
/* ============================================================
   Custom GTK Theme: $NAME
   Mode: $MODE
   Accent: $ACCENT
   ============================================================ */

/* Core accent colors */
@define-color accent_color $ACCENT;
@define-color accent_bg_color $ACCENT;
@define-color accent_fg_color $ACCENT_FG;

/* Selection / highlight */
@define-color theme_selected_bg_color $ACCENT;
@define-color theme_selected_fg_color $ACCENT_FG;
@define-color selected_bg_color $ACCENT;
@define-color selected_fg_color $ACCENT_FG;

/* Base colors */
@define-color theme_bg_color $BG_COLOR;
@define-color theme_fg_color $FG_COLOR;
@define-color theme_base_color $BASE_COLOR;
@define-color theme_text_color $FG_COLOR;

@define-color bg_color $BG_COLOR;
@define-color fg_color $FG_COLOR;
@define-color base_color $BASE_COLOR;
@define-color text_color $FG_COLOR;

/* Window / view / header */
@define-color window_bg_color $BG_COLOR;
@define-color window_fg_color $FG_COLOR;
@define-color view_bg_color $VIEW_BG;
@define-color view_fg_color $FG_COLOR;
@define-color headerbar_bg_color $HEADER_BG;
@define-color headerbar_fg_color $FG_COLOR;
@define-color popover_bg_color $BASE_COLOR;
@define-color popover_fg_color $FG_COLOR;
@define-color card_bg_color $BASE_COLOR;
@define-color card_fg_color $FG_COLOR;
@define-color sidebar_bg_color $BG_COLOR;
@define-color sidebar_fg_color $FG_COLOR;

/* Borders & misc */
@define-color borders $BORDERS;
@define-color borders_color $BORDERS;
@define-color theme_unfocused_fg_color $FG_COLOR;
@define-color theme_unfocused_bg_color $BG_COLOR;
@define-color theme_unfocused_base_color $BASE_COLOR;
@define-color theme_unfocused_selected_bg_color $ACCENT;
@define-color theme_unfocused_selected_fg_color $ACCENT_FG;

/* Warning / error / success (kept reasonable) */
@define-color warning_color #f5c211;
@define-color error_color   #e01b24;
@define-color success_color #2ec27e;

/* ============================================================
   Basic overrides so the accent is actually used
   ============================================================ */

/* Buttons, switches, checkboxes, progress bars, etc. */
button.suggested-action,
button.destructive-action,
.suggested-action,
.destructive-action,
switch:checked,
check:checked,
radio:checked,
progressbar trough progress,
scale highlight,
.accent {
    background-color: @accent_bg_color;
    color: @accent_fg_color;
}

/* Selected items */
*:selected,
row:selected,
.view:selected,
treeview:selected,
list row:selected {
    background-color: @theme_selected_bg_color;
    color: @theme_selected_fg_color;
}

/* Links */
a, link {
    color: @accent_color;
}
EOF
)

# Write the CSS files
echo "$CSS_CONTENT" > "$THEME_DIR/gtk-3.0/gtk.css"
echo "$CSS_CONTENT" > "$THEME_DIR/gtk-4.0/gtk.css"

# Also create a dark/light specific file name that some tools look for
if [[ "$MODE" == "dark" ]]; then
    cp "$THEME_DIR/gtk-3.0/gtk.css" "$THEME_DIR/gtk-3.0/gtk-dark.css"
    cp "$THEME_DIR/gtk-4.0/gtk.css" "$THEME_DIR/gtk-4.0/gtk-dark.css"
fi

echo
echo "✓ Theme created successfully!"
echo
echo "How to use it:"
echo "  1. Open GNOME Tweaks → Appearance → Applications"
echo "     (or your DE’s theme selector) and choose \"$NAME\""
echo
echo "  2. Or set it from the terminal:"
echo "     gsettings set org.gnome.desktop.interface gtk-theme '$NAME'"
echo
echo "  3. For libadwaita / modern GNOME apps you may also want:"
echo "     gsettings set org.gnome.desktop.interface color-scheme 'prefer-$MODE'"
echo
echo "Theme location: $THEME_DIR"
