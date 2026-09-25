import QtQuick
import "data"

QtObject {
    readonly property real value: Temperature.cpuTemperature
    readonly property string label: Math.round(value) + "°C"
    readonly property string icon: "󰔏"
    readonly property string state: value >= 80 ? "critical"
        : value >= 65 ? "warning"
        : "ok"
}
