-- Applications
local terminal = "kitty"
local fileManager = "nautilus"
local applauncher = "rofi -show drun --drun-prompt 'Launch: '"

-- Modifiers
local mainMod = "SUPER"
local swapMod = "SUPER + ALT"
local screenChangeMod = "SUPER + SHIFT"
local workspaceMod = "SUPER + CTRL"

-- Keybinds
hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind(mainMod .. " + ALT + F10", hl.dsp.exec_cmd("wpctl set-mute, @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind(mainMod .. " + F7", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind(mainMod .. " + F9", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind(mainMod .. " + F8", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprshot -m region"))

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(applauncher))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker -a"))

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())

hl.bind(swapMod .. " + left", hl.dsp.window.swap({ direction = "l" }))
hl.bind(swapMod .. " + right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(swapMod .. " + down", hl.dsp.window.swap({ direction = "d" }))
hl.bind(swapMod .. " + up", hl.dsp.window.swap({ direction = "u" }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))

hl.bind(screenChangeMod .. " + left", hl.dsp.window.move({ monitor = "l" }))
hl.bind(screenChangeMod .. " + right", hl.dsp.window.move({ monitor = "r" }))

hl.bind("F11", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(workspaceMod .. " + left", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(workspaceMod .. " + right", hl.dsp.focus({ workspace = "m+1" }))

hl.bind(workspaceMod .. " + W", hl.dsp.exec_cmd("bash -c 'NEW_WS=$(hyprctl workspaces -j | jq \"[.[].id] | max + 1\"); hyprctl dispatch workspace \"$NEW_WS\"; hyprctl keyword workspace \"$NEW_WS, persistent:true\"'"))
hl.bind(workspaceMod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.global("quickshell:togglePopoutSliderMenu"))

-- Submaps
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()

    hl.bind("A", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("D", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("S", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("W", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })

    hl.bind("left", hl.dsp.focus({ direction = "left" }))
    hl.bind("right", hl.dsp.focus({ direction = "right" }))
    hl.bind("down", hl.dsp.focus({ direction = "down" }))
    hl.bind("up", hl.dsp.focus({ direction = "up" }))

    hl.bind("R", hl.dsp.submap("reset"))
end)