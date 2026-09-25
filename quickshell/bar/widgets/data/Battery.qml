pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    readonly property var device: UPower.displayDevice
    readonly property bool available: device !== null
    readonly property real percentage: available ? device.percentage * 100 : 0
    readonly property bool charging: available
        && (device.state === UPowerDeviceState.Charging
            || device.state === UPowerDeviceState.FullyCharged)
}
