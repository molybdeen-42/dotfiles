require "modules/hyprbinds"
require "modules/hyprwindows"
require "modules/hyprworkspaces"
require "modules/hypranimations"
require "modules/hyprstart"

-- Monitors
hl.monitor({
    output = "DP-9",
    mode = "2560x1440@59.951",
    position = "-1152x0",
    scale = "1.25",
    transform = 1,
})

hl.monitor({
    output = "DP-11",
    mode = "2560x1440@59.951",
    position = "0x0",
    scale = "1",
})

hl.monitor({
    output = "eDP-1",
    mode = "2880x1920@120",
    position = "2560x0",
    scale = "2",
})