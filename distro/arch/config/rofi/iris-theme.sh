#!/bin/bash

source ~/.cache/iris/colors.sh

cat > ~/.config/rofi/iris.rasi <<EOF
* {
    bg: $bg;
    surface: $surface;
    fg: $fg;
    dim: $dim;
    accent: $accent;

    background-color: @bg;
    text-color: @fg;
    border-color: @accent;
}

window {
    background-color: @bg;
    border: 2px;
    border-color: @accent;
    border-radius: 12px;
    padding: 12px;
}

mainbox {
    background-color: transparent;
    children: [ inputbar, listview ];
    spacing: 10px;
}

inputbar {
    background-color: @surface;
    border-radius: 8px;
    padding: 10px;
    children: [ prompt, entry ];
}

prompt {
    text-color: @accent;
}

entry {
    text-color: @fg;
    placeholder-color: @dim;
}

listview {
    background-color: transparent;
    columns: 1;
    spacing: 5px;
    lines: 8;
}

element {
    background-color: transparent;
    text-color: @fg;
    border-radius: 6px;
    padding: 8px;
}

element selected {
    background-color: @surface;
    text-color: @accent;
}

element-text {
    background-color: transparent;
    text-color: inherit;
}

element-icon {
    background-color: transparent;
}
EOF
