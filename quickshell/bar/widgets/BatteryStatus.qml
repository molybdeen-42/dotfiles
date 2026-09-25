import QtQuick
import "data"

QtObject {
    readonly property bool present: Battery.available
    readonly property real value: Battery.percentage
    readonly property bool plugged: Battery.charging

    readonly property string label: present ? Math.round(value) + "%" : "N/A"

    readonly property string state: !present ? "unknown"
        : plugged ? "charging"
        : value <= 10 ? "critical"
        : value <= 20 ? "warning"
        : "ok"

    readonly property string icon: {
        if (!present) return ""
        const chargeIcons = ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
        const plainIcons = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰁿", "󰂂", "󰂂", "󰁹"]
        const idx = Math.max(0, Math.min(9, Math.floor(value / 10)))
        return (plugged ? chargeIcons : plainIcons)[idx]
    }
}
