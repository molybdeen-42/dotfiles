import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls
import "../widgets"
import "../widgets/data"
import "../../themes"
import "../../popout"

// The minimalistic moldybar bar
Scope {
    property bool isExpanded: true
    readonly property string networkType: Network.networkType

    Variants {
        model: Quickshell.screens

        Scope {
            id: screenBorder

            // Standard variables
            required property var modelData
            readonly property int topThickness: 35
            readonly property int edgeThickness: 6
            readonly property int radius: 5
            readonly property int borderThickness: 1
            readonly property int slantDistance: 6
            readonly property int interTabDistance: 25

            readonly property int shadowThickness: 4
            readonly property int cornerShadowModifier: 13
            readonly property color shadowColor: Theme.border
            readonly property color shadowEdge: "transparent"

            readonly property int wsWidth: 24
            readonly property int wsWidthExtend: 6 // Extends the active workspace in the workspace widget. Must be an even number!
            
            readonly property int chevronWidth: 10
            readonly property int itemSpacing: 8
            readonly property int iconSize: 18

            property int _topRefresh: 0

            // Gradients
            property Gradient activeGradient: RadialGradient {
                focalX: 0
                focalY: 0 
                centerRadius: 50
                GradientStop { position: 0; color: Theme.gradient1 }
                GradientStop { position: 0.27; color: Theme.gradient1 }
                GradientStop { position: 0.53; color: Theme.gradient2 }
                GradientStop { position: 0.73; color: Theme.gradient3 }
                GradientStop { position: 0.97; color: Theme.gradient4 }
                GradientStop { position: 1; color: Theme.gradient5 }
            }

            property Gradient inactiveGradient: RadialGradient {
                focalX: 0
                focalY: 0 
                centerRadius: 100
                GradientStop { position: 0; color: Theme.bg }
            }

            property Gradient activeTrayGradient: RadialGradient {
                focalX: 0
                focalY: 0 
                centerRadius: 25
                GradientStop { position: 0; color: Theme.gradient1 }
                GradientStop { position: 0.27; color: Theme.gradient1 }
                GradientStop { position: 0.53; color: Theme.gradient2 }
                GradientStop { position: 0.73; color: Theme.gradient3 }
                GradientStop { position: 0.97; color: Theme.gradient4 }
                GradientStop { position: 1; color: Theme.gradient5 }
            }

            property Gradient inactiveTrayGradient: RadialGradient {
                focalX: 0
                focalY: 0 
                centerRadius: 25
                GradientStop { position: 0; color: Qt.darker(Theme.gradient1, 1.2) }
                GradientStop { position: 0.27; color: Qt.darker(Theme.gradient1, 1.2) }
                GradientStop { position: 0.53; color: Qt.darker(Theme.gradient2, 1.2) }
                GradientStop { position: 0.73; color: Qt.darker(Theme.gradient3, 1.2) }
                GradientStop { position: 0.97; color: Qt.darker(Theme.gradient4, 1.2) }
                GradientStop { position: 1; color: Qt.darker(Theme.gradient5, 1.2) }
            }

            // Application icons
            function iconForClass(className) {
                var map = {
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

            // Timers
            Timer {
                id: refreshTimer
                interval: 1500
                repeat: false
                onTriggered: {
                    Hyprland.refreshToplevels()
                    _topRefresh++
                }
            }

            Timer {
                id: secondRefreshTimer
                interval: 3000
                repeat: false
                onTriggered: {
                    Hyprland.refreshToplevels()
                    _topRefresh++
                }
            }

            // Active monitor
            Connections {
                target: Hyprland.focusedMonitor
                function onActiveWorkspaceChanged() {
                    refreshTimer.restart()
                    secondRefreshTimer.restart()
                }
            }  

            // Workspaces
            PanelWindow {
                screen: screenBorder.modelData
                color: "transparent"
                implicitHeight: topThickness
                exclusiveZone: topThickness - 7

                anchors {
                    left: true
                    top: true
                    right: true
                }

                Item {
                    anchors.fill: parent

                    Row {
                        id: leftRow
                        spacing: -slantDistance

                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: clockShape.left
                            rightMargin: interTabDistance + slantDistance
                        }

                        Repeater {
                            id: wsRepeater
                            model: (Hyprland.workspaces.values
                                .filter(ws => ws.monitor && ws.monitor.name === modelData.name)
                                .sort((x, y) => x.id - y.id)
                            )
                            
                            Shape {
                                id: wsShape

                                // Variables to determine the shape of the widget
                                property bool isFirst: index === 0
                                property bool isLast: index === wsRepeater.count - 1
                                property bool isActive: modelData === Hyprland.focusedMonitor.activeWorkspace

                                // Icon for active application on workspace
                                property string currentIcon: {
                                    var _dep = screenBorder._topRefresh

                                    var tops = Array.from(modelData.toplevels.values)
                                    if (tops.length === 0) return ""

                                    for (var i = 0; i < tops.length; i++) {
                                        if (!tops[i]) continue
                                        if (tops[i].activated) {
                                            var ipc = tops[i].lastIpcObject
                                            return ipc ? iconForClass(ipc["class"]) : ""
                                        }
                                    }

                                    var last = tops[tops.length - 1]
                                    return (last && last.lastIpcObject) ? iconForClass(last.lastIpcObject["class"]) : ""
                                }

                                onCurrentIconChanged: {
                                    if (currentIcon === "\u{f0614}") {
                                        refreshTimer.restart()
                                        secondRefreshTimer.restart()
                                    }
                                }

                                width: wsWidth + (isActive ? wsWidthExtend : 0) + ((isFirst || isLast) ? radius : slantDistance) + slantDistance
                                implicitHeight: clockWidget.implicitHeight

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 500
                                        easing.type: Easing.InOutQuad
                                    }
                                }

                                // Workspace widget shape
                                ShapePath {
                                    fillGradient: isActive ? activeGradient : inactiveGradient
                                    strokeColor: Theme.border
                                    strokeWidth: borderThickness

                                    startX: isFirst ? radius : 0
                                    startY: clockWidget.height

                                    PathLine {
                                        x: isLast ? wsShape.width - radius : wsShape.width - slantDistance
                                        y: clockWidget.height
                                    }

                                    PathArc {
                                        x: isLast ? wsShape.width - radius : wsShape.width
                                        y: 0
                                        radiusX: isLast ? radius : 0
                                        radiusY: isLast ? radius : 0
                                        direction: PathArc.Counterclockwise
                                    }

                                    PathLine {
                                        x: isFirst ? radius : slantDistance
                                        y: 0
                                    }

                                    PathArc {
                                        x: isFirst ? radius : 0
                                        y: clockWidget.height
                                        radiusX: isFirst ? radius : 0
                                        radiusY: isFirst ? radius : 0
                                        direction: PathArc.Counterclockwise
                                    }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: currentIcon 
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeLarge
                                    color: isActive ? Theme.bg : Theme.widget
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        Hyprland.dispatch("workspace " + modelData.id)
                                    }
                                }
                            }
                        }
                    }

                    // Clock widget
                    Shape {
                        id: clockShape
                        anchors.centerIn: parent
                        implicitWidth: clockWidget.implicitWidth + (2 * radius)
                        implicitHeight: clockWidget.implicitHeight

                        ClockWidget {
                            id: clockWidget
                            anchors.centerIn: parent
                            rightPadding: radius + 5
                            leftPadding: radius
                        }

                        ShapePath {
                            fillColor: Theme.bg
                            strokeColor: Theme.border
                            strokeWidth: borderThickness

                            startX: radius
                            startY: clockWidget.height

                            PathLine {
                                x: clockWidget.width - radius
                                y: clockWidget.height
                            }

                            PathArc {
                                x: clockWidget.width - radius
                                y: 0
                                radiusX: radius
                                radiusY: radius
                                direction: PathArc.Counterclockwise
                            }

                            PathLine {
                                x: radius
                                y: 0
                            }

                            PathArc {
                                x: radius
                                y: clockWidget.height
                                radiusX: radius
                                radiusY: radius
                                direction: PathArc.Counterclockwise
                            }
                        }
                    }

                    // Row of widgets
                    Shape {
                        id: widgetShape
                        implicitHeight: clockWidget.implicitHeight
                        width: widgetRow.width + (2 * radius)

                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: clockShape.right
                            leftMargin: interTabDistance
                        }

                        Row {
                            id: widgetRow
                            anchors.centerIn: parent
                            spacing: 16
                            height: clockWidget.height

                            // Internet connection icon
                            Text {
                                property string networkIcon: {
                                    if (networkType === "ethernet") return "󰈀";
                                    if (networkType === "wifi") return "󰖩";
                                    return "󰖪";
                                }

                                width: 16
                                text: networkIcon
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeLarge
                                color: Theme.widget
                                leftPadding: 2
                            }

                            // CPU temperature icon
                            Item {
                                id: cpuTemp
                                width: cpuRow.width
                                height: parent.height

                                readonly property real temperature: Temperature.cpuTemperature

                                // Color on icon
                                readonly property color cpuColor: {
                                    if (cpuTemp.temperature >= 80) return Theme.notify
                                    if (cpuTemp.temperature >= 65) return Theme.accentHover
                                    return Theme.widget
                                }

                                Row {
                                    id: cpuRow
                                    anchors.centerIn: parent
                                    spacing: 4

                                    Text {
                                        text: "\uf4bc"
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSizeLarge
                                        color: cpuTemp.cpuColor
                                    }

                                    Text {
                                        text: Math.round(cpuTemp.temperature) + "°C"
                                        font.family: Theme.fontFamily
                                        font.pixelSize: Theme.fontSizeLarge
                                        color: cpuTemp.cpuColor
                                    }
                                }
                            }

                            // Battery charge icon
                            Item {
                                id: battery
                                width: batteryRow.width
                                height: parent.height

                                readonly property var power: UPower.displayDevice

                                property string batteryIcon: {
                                    if (!power) return ""

                                    var pct = power.percentage * 100

                                    // Icons while charging
                                    if (power.state === UPowerDeviceState.Charging ||
                                        power.state === UPowerDeviceState.FullyCharged) {
                                        if (Math.round(pct) === 100) return "󰁹"
                                        if (pct >= 90) return "󰂅"
                                        if (pct >= 80) return "󰂋"
                                        if (pct >= 70) return "󰂊"
                                        if (pct >= 60) return "󰢞"
                                        if (pct >= 50) return "󰂉"
                                        if (pct >= 40) return "󰢝"
                                        if (pct >= 30) return "󰂈"
                                        if (pct >= 20) return "󰂇"
                                        if (pct >= 10) return "󰂆"
                                        return "󰢜"
                                    }

                                    // Icons while discharging
                                    if (Math.round(pct) === 100) return "󰁹"
                                    if (pct >= 90) return "󰁹"
                                    if (pct >= 80) return "󰂂"
                                    if (pct >= 70) return "󰂁"
                                    if (pct >= 60) return "󰂀"
                                    if (pct >= 50) return "󰁿"
                                    if (pct >= 40) return "󰁾"
                                    if (pct >= 30) return "󰁽"
                                    if (pct >= 20) return "󰁼"
                                    if (pct >= 10) return "󰁻"
                                    return "󰁺"
                                }

                                // Color on icon
                                readonly property color iconColor: {
                                    if (!battery.power) return Theme.widget
                                    if (Math.round(battery.power.percentage * 100) === 100) return Theme.widget
                                    if (battery.power.state === UPowerDeviceState.Charging) return Theme.positive
                                    if (battery.power.percentage * 100 <= 10) return Theme.notify
                                    if (battery.power.percentage * 100 <= 20) return Theme.warn
                                    return Theme.widget
                                }

                                Row {
                                    id: batteryRow
                                    anchors.centerIn: parent
                                    spacing: 4

                                    Text {
                                        text: battery.batteryIcon
                                        color: battery.iconColor
                                        font.pixelSize: Theme.fontSizeLarge - 2
                                        font.family: Theme.fontFamily
                                    }

                                    Text {
                                        text: battery.power ? Math.round(battery.power.percentage * 100) + "%" : "N/A"
                                        color: battery.iconColor
                                        font.pixelSize: Theme.fontSizeLarge
                                    }
                                }
                            }
                        }

                        // Widgetrow shape
                        ShapePath {
                            fillColor: Theme.bg
                            strokeColor: Theme.border
                            strokeWidth: borderThickness

                            startX: radius
                            startY: clockWidget.height

                            PathLine {
                                x: widgetShape.width - radius
                                y: clockWidget.height
                            }

                            PathArc {
                                x: widgetShape.width - radius
                                y: 0
                                radiusX: radius
                                radiusY: radius
                                direction: PathArc.Counterclockwise
                            }

                            PathLine {
                                x: radius
                                y: 0
                            }

                            PathArc {
                                x: radius
                                y: clockWidget.height
                                radiusX: radius
                                radiusY: radius
                                direction: PathArc.Counterclockwise
                            }
                        }
                    }

                    // System tray
                    Shape {
                        id: tray
                        implicitHeight: clockWidget.implicitHeight
                        height: clockWidget.height
                        width: chevronWidth + (isExpanded ? trayItems.implicitWidth : 0)

                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: widgetShape.right
                            leftMargin: interTabDistance
                        }

                        Behavior on implicitWidth {
                            NumberAnimation {
                                duration: 220
                                easing.type: Easing.OutCubic
                            }
                        }

                        // Shape of extended tray
                        ShapePath {
                            fillColor: Theme.bg
                            strokeColor: Theme.border
                            strokeWidth: borderThickness

                            startX: radius
                            startY: tray.height

                            PathLine {
                                x: tray.width - radius
                                y: tray.height
                            }

                            PathArc {
                                x: tray.width - radius
                                y: 0
                                radiusX: radius
                                radiusY: radius
                                direction: PathArc.Counterclockwise
                            }

                            PathLine {
                                x: radius
                                y: 0
                            }

                            PathArc {
                                x: radius
                                y: tray.height
                                radiusX: radius
                                radiusY: radius
                                direction: PathArc.Counterclockwise
                            }
                        }

                        // Chevron icon
                        Shape {
                            id: chevron
                            width: radius * 2
                            height: tray.height

                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                            }

                            // Shape
                            ShapePath {
                                fillGradient: isExpanded ? activeTrayGradient : inactiveTrayGradient
                                strokeColor: Theme.border
                                strokeWidth: borderThickness

                                startX: radius
                                startY: 0

                                PathArc {
                                    x: radius
                                    y: tray.height
                                    radiusX: radius
                                    radiusY: radius
                                    direction: PathArc.Counterclockwise
                                }

                                PathArc {
                                    x: radius
                                    y: 0
                                    radiusX: radius
                                    radiusY: radius
                                    direction: PathArc.Counterclockwise
                                }
                            }

                            Text {
                                text: "❯"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeLarge
                                anchors.centerIn: parent
                                color: Theme.widget
                                rotation: isExpanded ? 0 : 180

                                Behavior on rotation {
                                    NumberAnimation {
                                        duration: 220
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: isExpanded = !isExpanded
                            }
                        }

                        // System tray entries
                        Row {
                            id: trayItems
                            spacing: itemSpacing
                            opacity: isExpanded ? 1 : 0
                            visible: opacity > 0.01
                            rightPadding: slantDistance * 2

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 180
                                }
                            }

                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: chevron.right
                                leftMargin: slantDistance * 2
                            }

                            Repeater {
                                model: SystemTray.items

                                delegate: Item {
                                    id: trayItem
                                    width: iconSize
                                    height: iconSize
                                    required property var modelData

                                    // Tray entry size
                                    Image {
                                        anchors.fill: parent
                                        source: trayItem.modelData.icon
                                        sourceSize.width: iconSize
                                        sourceSize.height: iconSize
                                        smooth: true
                                        asynchronous: true
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    // Mouse interaction on tray entries
                                    MouseArea {
                                        anchors.fill: parent
                                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: (mouse) => {
                                            if (mouse.button === Qt.LeftButton) {
                                                trayItem.modelData.activate()
                                            } else if (mouse.button === Qt.MiddleButton) {
                                                trayItem.modelData.secondaryActivate()
                                            } else if (mouse.button === Qt.RightButton) {
                                                trayItem.modelData.display(
                                                    QsWindow.window,
                                                    trayItem.mapToItem(null, 0, trayItem.height).x,
                                                    trayItem.mapToItem(null, 0, trayItem.height).y
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
