
hl.window_rule({
    name = "steam=floating",
    match = { class = "steam$", initial_class = "^steam$" },

    no_focus = false,
    float = true,
    center = true,
    size = { 1680, 1050 },
})

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
    name = "mpv=floating",
    match = { class = "^mpv$" },

    float = true,
    center = true,
    size = { 1920, 1080 },
})

hl.window_rule({
    name = "Qalculate-floating",
    match = { class = "^qalculate-gtk$" },
    
    float = true,
})
