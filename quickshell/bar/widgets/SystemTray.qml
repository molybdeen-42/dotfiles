import Quickshell
import Quickshell.Services.SystemTray
import QtQuick

QtObject {
    readonly property var items: SystemTray.items

    readonly property int count: SystemTray.items.values.length

    function activate(entry) {
        entry.activate()
    }

    function secondaryActivate(entry) {
        entry.secondaryActivate()
    }

    function openMenu(entry, window, x, y) {
        entry.display(window, x, y)
    }
}
