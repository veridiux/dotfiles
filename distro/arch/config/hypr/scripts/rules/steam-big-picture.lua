-- Steam Big Picture → fullscreen
hl.window_rule({
    name = "steam-big-picture-fullscreen",
    match = {
        class = "steam",
        title = "Steam Big Picture Mode",
    },
    fullscreen = true,
})

-- Steam games / gamescope / Wine → workspace 5 + fullscreen
hl.window_rule({
    name = "steam-games-workspace-fullscreen",
    match = {
        class = "^(steam_app_.*|gamescope|wine|Wine|.*\\.exe)$",
    },
    workspace = 5,
    fullscreen = true,
})
