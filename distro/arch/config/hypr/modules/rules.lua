hl.window_rule({
    name = "battlenet-floating",
    match = {
        initial_class = "steam_app_default",
        title = "Battle.net",
    },

    no_focus = false,
    float = true,
    center = true,
    size = { 1680, 1050 },
})

hl.window_rule({
    name = "steam-floating",
    match = {
        initial_class = "steam",
        initial_title = "Steam",
    },

    no_focus = false,
    float = true,
    center = true,
    size = { 1680, 1050 },
})

hl.window_rule({
    name = "steam-friends-floating",
    match = {
        initial_class = "steam",
        initial_title = "Friends List",
    },

    no_focus = false,
    float = true,
    center = true,
    size = { 300, 1050 },
})

hl.window_rule({
    name = "steam-big-picture-fullscreen",
    match = {
        initial_class = "steam",
        initial_title = "Steam Big Picture Mode",
    },

    fullscreen = true,
})

hl.on("window.active", function(w)
    if w and w.class == "steam" and w.title == "Steam Big Picture Mode" then
        hl.dispatch(hl.dsp.window.fullscreen({
            action = "set",
            mode = "fullscreen",
        }))
    end
end)

hl.window_rule({
    name = "discord-floating",
    match = { class = "^discord$" },

    float = true,
})

hl.window_rule({
    name = "blueberry-floating",
    match = { class = "^blueberry.py$" },
    float = true,
})

hl.window_rule({
    name = "pavu-floating",
    match = { class = "^org.pulseaudio.pavucontrol$" },
    
    float = true,
    center = true,
})


hl.window_rule({
    name = "network-floating",
    match = { class = "^nm-connection-editor$" },

    float = true,
    center = true,
})

hl.window_rule({
    name = "ytmcli-floating",
    match = { class = "^youtube-music-cli$" },

    float = true,
    center = true,
    size = { 975, 475 },
})

hl.window_rule({
    name = "mpv=floating",
    match = { class = "^mpv$" },

    float = true,
    center = true,
    size = { 1920, 1080 },
})

hl.window_rule({
    name = "ytm-floating",

    match = {
        initial_class = "brave-music.youtube.com__-Default",
    },

    float = true,
    center = true,
    size = { 1680, 1050 },
})

hl.window_rule({
    name = "Qalculate-floating",
    match = { class = "^qalculate-gtk$" },
    
    float = true,
})

hl.window_rule({
    name = "Battle.net-floating",
    match = {
        class = "^steam_app_default$",
        title = "^Battle%.net$",
    },

    no_focus = false,
    float = true,
    center = true,
    size = { 1680, 1050 },
})

hl.window_rule({
    name = "once-human-fullscreen",
    match = {
        initial_class = "steam_app_2139460",
        initial_title = "ONCE_HUMAN",
    },

    fullscreen = true,
})

-- Diablo III
hl.window_rule({
    match = {
        class = "steam_app_default",
        title = "Diablo III",
    },
    fullscreen = true,
})

-- Hide Wine / Battle.net tray window
hl.window_rule({
    match = {
        class = "steam_app_default",
        title = "^$",
    },

    float = true,
    move = { -10000, -10000 },
})
