#!/usr/bin/env bash

set -euo pipefail

# ============================================================
#  Create a custom GTK theme (light or dark) with custom accent
#  Fixed version – no more transparent backgrounds
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

[[ $# -eq 3 ]] || usage

NAME="$1"
MODE="$2"
ACCENT="$3"

if [[ "$MODE" != "light" && "$MODE" != "dark" ]]; then
    echo "Error: mode must be 'light' or 'dark'"
    exit 1
fi

if [[ ! "$ACCENT" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
    echo "Error: accent color must be a 6-digit hex value, e.g. #3584e4"
    exit 1
fi

# Decide text color on the accent
is_light_color() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    local luma=$(( (r * 299 + g * 587 + b * 114) / 1000 ))
    (( luma > 160 ))
}

if is_light_color "$ACCENT"; then
    ACCENT_FG="#1a1a1a"
else
    ACCENT_FG="#ffffff"
fi

# Base colors
if [[ "$MODE" == "light" ]]; then
    BG_COLOR="#fafafa"
    FG_COLOR="#2e3436"
    BASE_COLOR="#ffffff"
    VIEW_BG="#ffffff"
    HEADER_BG="#f0f0f0"
    BORDERS="#c0c0c0"
else
    BG_COLOR="#242424"
    FG_COLOR="#eeeeec"
    BASE_COLOR="#1e1e1e"
    VIEW_BG="#1e1e1e"
    HEADER_BG="#2d2d2d"
    BORDERS="#3d3d3d"
fi

THEME_DIR="$HOME/.themes/$NAME"

echo "Creating theme: $NAME ($MODE) with accent $ACCENT"
echo "→ $THEME_DIR"

mkdir -p "$THEME_DIR/gtk-3.0" "$THEME_DIR/gtk-4.0"

# index.theme
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

# Improved CSS that actually paints backgrounds
CSS_CONTENT=$(cat <<EOF
/* ============================================================
   Custom GTK Theme: $NAME
   Mode: $MODE
   Accent: $ACCENT
   ============================================================ */

/* Colors */
@define-color accent_color $ACCENT;
@define-color accent_bg_color $ACCENT;
@define-color accent_fg_color $ACCENT_FG;

@define-color theme_selected_bg_color $ACCENT;
@define-color theme_selected_fg_color $ACCENT_FG;
@define-color selected_bg_color $ACCENT;
@define-color selected_fg_color $ACCENT_FG;

@define-color theme_bg_color $BG_COLOR;
@define-color theme_fg_color $FG_COLOR;
@define-color theme_base_color $BASE_COLOR;
@define-color theme_text_color $FG_COLOR;

@define-color bg_color $BG_COLOR;
@define-color fg_color $FG_COLOR;
@define-color base_color $BASE_COLOR;
@define-color text_color $FG_COLOR;

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

@define-color borders $BORDERS;
@define-color borders_color $BORDERS;

/* ============================================================
   Force solid backgrounds (this is the important part)
   ============================================================ */

window,
.background,
.csd,
decoration,
headerbar,
.titlebar,
notebook,
view,
.view,
list,
listview,
scrolledwindow,
frame,
.frame,
box,
grid,
stack,
.stack,
.card {
    background-color: @theme_bg_color;
    color: @theme_fg_color;
}

window.csd,
window.solid-csd {
    background-color: @theme_bg_color;
}

headerbar,
.titlebar {
    background-color: @headerbar_bg_color;
    color: @headerbar_fg_color;
}

/* Accent elements */
button.suggested-action,
.suggested-action,
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

echo "$CSS_CONTENT" > "$THEME_DIR/gtk-3.0/gtk.css"
echo "$CSS_CONTENT" > "$THEME_DIR/gtk-4.0/gtk.css"

if [[ "$MODE" == "dark" ]]; then
    cp "$THEME_DIR/gtk-3.0/gtk.css" "$THEME_DIR/gtk-3.0/gtk-dark.css"
    cp "$THEME_DIR/gtk-4.0/gtk.css" "$THEME_DIR/gtk-4.0/gtk-dark.css"
fi

echo
echo "✓ Theme created successfully (with solid backgrounds)!"
echo "Theme location: $THEME_DIR"