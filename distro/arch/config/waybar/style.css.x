/* Sys0p Waybar Ultra Compact */

@define-color critical #ff0000;
@define-color alert #df3320;
@define-color fgcolor #ffffff;
@define-color bgcolor #222436;

@define-color accent5 #7da6ff;
@define-color power_color #a45ad0;
@define-color lock_color #9c7ce8;

@define-color workspace_active #9d7bd8;
@define-color workspace_hover #b8a2e6;

* {
    font-family: "Hack Nerd Font";
    font-weight: bold;
    min-width: 10px;
    font-size: 98%;
    font-feature-settings: "zero","ss01","ss02","ss03","ss04","ss05","cv31";
}

window#waybar {
    background-color: rgba(0,0,0,0.3);
    color: @fgcolor;
    border-radius: 10px;
    transition: background-color 0.5s;
}
window#waybar.hidden { opacity: 0.1; }

tooltip {
    background: #1e1e2e;
    opacity: 0.6;
    border-radius: 10px;
    border: 2px solid #11111b;
}

#custom-separator { color: #606060; }
#custom-separator.line-tray { color: #4a6b8a; }

#workspaces button {
    background: transparent;
    border: none;
    outline: none;
    padding: 2px 3px;
    margin: 0 4px;
    transition: all 0.5s cubic-bezier(0.55,-0.68,0.48,1.682);
    color: #3a3a4a;
}
#workspaces button.active,
#workspaces button.focused { color: @workspace_active; }
#workspaces button.hover { color: @workspace_hover; }
#workspaces button.urgent { color: @power_color; }

#clock, #bluetooth, #backlight, #wireplumber, #idle_inhibitor,
#network, #custom-arch { color: @accent5; }

#battery {
    min-width: 55px;
    color: @accent5;
}
#backlight, #wireplumber { font-family: monospace; min-width: 55px; }
#idle_inhibitor { min-width: 14px; margin-left: 3px; padding-bottom: 1px; }
#network { padding: 0 2px 0 3px; }
#network.disconnected { color: @alert; }

#battery.critical:not(.charging) {
    color: @critical;
    animation-name: blink;
    animation-duration: 3s;
    animation-timing-function: steps(12);
    animation-iteration-count: infinite;
    animation-direction: alternate;
}
@keyframes blink { to { background-color: @critical; color: @bgcolor; } }

#custom-power { color: @power_color; }
#custom-lock { color: @lock_color; }

#custom-logo {
    padding: 0 5px;
    font-size: 22px;
    border-radius: 6px;
    background-color: transparent;
    min-width: 30px;
    color: #cdd6f4;
}
#custom-logo.Integrated { background-color: rgba(100,200,100,0.3); color: #a6e3a1; }
#custom-logo.Hybrid { background-color: rgba(255,215,0,0.3); color: #f9e2af; }
#custom-logo.Dedicated { background-color: rgba(255,80,80,0.3); color: #f38ba8; }

#tray { background-color: transparent; border: none; box-shadow: none; margin-right: 2px; padding-top: 2px; }
#tray > * { padding: 0 4px; }

#mpris { margin: 0 10px; padding: 0 10px; border-radius: 8px; background-color: transparent; color: rgb(160,190,240); font-weight: bold; }

