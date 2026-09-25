import Quickshell
import QtQuick
import "../themes"

PanelWindow {
    id: root

    property var entry: null
    property real menuX: 0
    property real menuY: 0

    visible: entry !== null
    color: "transparent"

    implicitHeight: screen ? screen.height : 0

    anchors {
        left: true
        right: true
        bottom: true
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onClicked: root.entry = null
    }

    QsMenuOpener {
        id: menuOpener
        menu: root.entry ? root.entry.menu : null
    }

    Rectangle {
        id: menuPanel

        x: root.menuX
        y: root.menuY
        width: 200
        height: menuColumn.height + 8

        color: Theme.bg
        border.width: 1
        border.color: Theme.border
        radius: 6

        MouseArea {
            anchors.fill: parent
        }

        Column {
            id: menuColumn
            x: 4
            y: 4
            width: parent.width - 8
            spacing: 2

            Repeater {
                model: menuOpener.children

                delegate: Rectangle {
                    id: menuItem

                    required property var modelData

                    readonly property bool isSeparator: modelData.isSeparator

                    width: menuColumn.width
                    height: isSeparator ? 9 : 26
                    radius: 4
                    color: isSeparator ? "transparent"
                        : (menuMouse.containsMouse ? Theme.accent : "transparent")

                    Rectangle {
                        visible: menuItem.isSeparator
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        height: 1
                        color: Theme.border
                    }

                    Text {
                        visible: !menuItem.isSeparator
                        anchors {
                            left: parent.left
                            leftMargin: 8
                            verticalCenter: parent.verticalCenter
                        }
                        text: modelData.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeNormal
                        color: menuItem.modelData.enabled ? Theme.text : Theme.textMuted
                    }

                    MouseArea {
                        id: menuMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        enabled: !menuItem.isSeparator
                        onClicked: {
                            if (menuItem.modelData.hasChildren) return
                            menuItem.modelData.triggered()
                            root.entry = null
                        }
                    }
                }
            }
        }
    }
}
