hl.window_rule({
    name  = "steam-no-focus",
    match = { class = "steam$", initial_class = "^steam$" },
    
    -- Prevent Steam from grabbing focus on launch
    no_focus = false,
    
    -- Optional: Force Steam to a specific workspace (e.g., workspace 9)
    -- workspace = "9",
    
    -- Optional: Make Steam float if you prefer non-tiling behavior for the library
     float = true,
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
