require "../theme"

-- General window settings
hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- Window borders
hl.config({
    general = {
        resize_on_border = true,
        extend_border_grab_area = 15,
        hover_icon_on_border = true,
        border_size = 2,
        col = {
            active_border = { 
                colors = { 
                    gradient1, 
                    gradient2,
                    gradient3, 
                    gradient4, 
                    gradient5
                }, 
                angle = 45 
            },
            inactive_border = inactive,
        },
        gaps_out = 8,
        gaps_in = 4,
    },
    input = {
        touchpad = {
            natural_scroll = true,
        },
    },
    -- Cursor
    cursor = {
        inactive_timeout = 3,
        hide_on_key_press = true,
    },
    -- Decoration
    decoration = {
        rounding = 5,
        border_part_of_window = true,
        inactive_opacity = 0.9,
        active_opacity = 1,
        dim_inactive = true,
        dim_strength = 0.15,
    },
})