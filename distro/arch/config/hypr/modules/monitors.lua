------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Names / descriptions from hyprctl monitors
local LAPTOP  = "eDP-1"
local ACER    = "desc:Acer Technologies Acer X34"
local SAMSUNG = "desc:Samsung Electric Company C27JG5x HTOK800290"


-- Laptop panel
local function enable_laptop()
    hl.monitor({
        output   = LAPTOP,
        mode     = "preferred",
        position = "0x0",
        scale    = "auto",
        vrr      = 2,
        bitdepth = 10,
        cm       = "auto",
        disabled = false,
    })
end


-- Acer X34 (primary monitor)
local function enable_acer()
    hl.monitor({
        output   = ACER,
        mode     = "3440x1440@100",
        position = "0x0",
        scale    = 1,
        vrr      = 2,
        bitdepth = 10,
        cm       = "auto",
        disabled = false,
    })
end


-- Samsung secondary monitor (left side)
local function enable_samsung()
    hl.monitor({
        output   = SAMSUNG,
        mode     = "2560x1440@120",
        position = "-2560x0",
        scale    = 1,
        vrr      = 2,
        bitdepth = 10,
        cm       = "auto",
        disabled = false,
    })
end


local function disable_laptop()
    hl.monitor({
        output = LAPTOP,
        disabled = true,
    })
end


-- Detect current setup
local function apply_layout()

    local acer = hl.get_monitor(ACER)
    local samsung = hl.get_monitor(SAMSUNG)

    if acer then
        -- Desktop setup:
        -- Acer = primary
        -- Samsung = left side (if connected)
        enable_acer()

        if samsung then
            enable_samsung()
        end

        disable_laptop()

    else
        -- Laptop only
        enable_laptop()
    end
end


-- Fallback for unknown monitors
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
    vrr      = 2,
    bitdepth = 10,
    cm       = "auto",
})


-- Apply on startup
apply_layout()


-- Reapply on monitor changes
hl.on("monitor.added", function()
    hl.timer(function()
        apply_layout()
    end, { timeout = 300, type = "oneshot" })
end)


hl.on("monitor.removed", function()
    hl.timer(function()
        apply_layout()
    end, { timeout = 300, type = "oneshot" })
end)
