import QtQuick
import "data"

QtObject {
    readonly property string state: Network.networkType
    readonly property string icon: state === "ethernet" ? "󰈀"
        : state === "wifi" ? "󰖩"
        : "󰖪"
    readonly property string label: state
}
