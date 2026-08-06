------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Names / descriptions from hyprctl monitors
local LAPTOP = "eDP-1"                          -- or "desc:Samsung Display Corp. ATNA40CU05-0"
local ACER   = "desc:Acer Technologies Acer X34" -- more reliable than the port name (DP-9)

-- Preferred settings for the laptop panel
local function enable_laptop()
    hl.monitor({
        output   = LAPTOP,
        mode     = "preferred",
        position = "auto",
        scale    = "auto",
        vrr      = 2,
        bitdepth = 10,
        cm       = "auto",
        disabled = false,
    })
end

-- Preferred settings for the Acer X34
local function enable_acer()
    hl.monitor({
        output   = ACER,
        mode     = "3440x1440@100",   -- or "3440x1440@100" if you want max refresh -- preferred
        position = "auto",
        scale    = 1,
        vrr      = 2,
        bitdepth = 10,
        cm       = "auto",
        disabled = false,
    })
end

local function disable_laptop()
    hl.monitor({
        output   = LAPTOP,
        disabled = true,
    })
end

-- Apply the correct layout right now
local function apply_layout()
    local acer = hl.get_monitor(ACER)

    if acer then
        -- Acer is present → turn laptop off and make sure Acer is configured
        enable_acer()
        disable_laptop()
    else
        -- No Acer → just enable the laptop
        enable_laptop()
    end
end

-- Fallback for any other monitor that might appear
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
    vrr      = 2,
    bitdepth = 10,
    cm       = "auto",
})

-- Run once at config load / startup
apply_layout()

-- React to hotplug
hl.on("monitor.added", function(mon)
    -- Small delay so the monitor is fully ready
    hl.timer(function()
        apply_layout()
    end, { timeout = 300, type = "oneshot" })
end)

hl.on("monitor.removed", function(mon)
    hl.timer(function()
        apply_layout()
    end, { timeout = 300, type = "oneshot" })
end)
