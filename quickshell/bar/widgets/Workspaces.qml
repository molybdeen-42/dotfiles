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
        }
        if (!className) return "\u{f0614}"
        return map[className.toLowerCase()] || "\u{f0614}"
    }

    function iconForWorkspace(ws) {
        const dep = root.refreshCount
        const tops = Array.from(ws.toplevels.values)
        if (tops.length === 0) return ""

        for (let i = 0; i < tops.length; i++) {
            if (!tops[i]) continue
            if (tops[i].activated) {
                const ipc = tops[i].lastIpcObject
                return ipc ? iconForClass(ipc["class"]) : ""
            }
        }

        const last = tops[tops.length - 1]
        return (last && last.lastIpcObject) ? iconForClass(last.lastIpcObject["class"]) : ""
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
