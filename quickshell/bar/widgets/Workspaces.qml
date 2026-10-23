import Quickshell
import Quickshell.Hyprland
import QtQuick

Item {
    id: root

    property string monitorName: ""
    property int refreshCount: 0

    readonly property var list: Hyprland.workspaces.values
        .filter(ws => ws.monitor && ws.monitor.name === monitorName)
        .sort((a, b) => a.id - b.id)

    readonly property var active: Hyprland.focusedMonitor
        ? Hyprland.focusedMonitor.activeWorkspace
        : null

    function switchTo(ws) {
        Hyprland.dispatch("workspace " + ws.id)
    }

    function iconForClass(className) {
        const map = {
            "kitty": "\uf120",
            "codium": "\uf121",
            "firefox": "\uf269",
            "discord": "\uf392",
            "osu!": "\u{f063c}",
            "virt-manager": "\ueb7b",
            "chatgpt": "\u{f06a9}",
            "ghidra-ghidra": "\uf188",
            "co.epilogue.playback": "\uf11b",
            "org.gnome.rhythmbox3": "\uf001",
            "org.pulseaudio.pavucontrol": "\uf028",
        }
        if (!className) return "\u{f0614}"
        return map[className.toLowerCase()] || "\u{f0614}"
    }

    function iconForWindow(ipc) {
        const className = (ipc["class"] || "").toLowerCase()
        const title = ipc["title"] || ""

        if (className === "kitty" && /^(?:codex|vibe)(?:\s|$)/i.test(title))
            return "\u{f06a9}"

        if (className === "kitty" && /^(?:nvim|nv|vim|v)(?:\s|$)/.test(title))
            return "\uf121"

        return iconForClass(className)
    }

    function iconForWorkspace(ws) {
        const dep = root.refreshCount
        const tops = Array.from(ws.toplevels.values)
        return tops
            .filter(top => top)
            .map(top => iconForWindow(top.lastIpcObject || {}))
            .join("  ")
    }

    Timer {
        interval: 2500
        running: true
        repeat: true
        onTriggered: {
            Hyprland.refreshToplevels()
            root.refreshCount++
        }
    }
}
