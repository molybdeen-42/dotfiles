import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Shapes
import "../widgets"
import "../widgets/data"
import "../../components"
import "../../themes"

Scope {
	id: root

	property bool toggleVisible: true

	GlobalShortcut {
		name: "toggleBar"
		onPressed: () => root.toggleVisible = !root.toggleVisible
	}

	readonly property int barHeight: 32
	readonly property int margin: 12
	readonly property int widgetMargin: 4
	readonly property int seperatorWidth: 8
	readonly property int trayEntrySize: 18
	readonly property int pillWidth: 26
	readonly property int pillHeight: 22
	readonly property int pillRadius: 0
	readonly property int workspaceSpacing: 6
	readonly property int extendActive: 6

	// Gradients
	readonly property Gradient activeGradient: RadialGradient {
    		focalX: 0
    		focalY: 0
    		centerRadius: 50
    		GradientStop { position: 0; color: Theme.gradient1 }
    		GradientStop { position: 0.25; color: Theme.gradient1 }
    		GradientStop { position: 0.50; color: Theme.gradient2 }
    		GradientStop { position: 0.75; color: Theme.gradient3 }
    		GradientStop { position: 0.97; color: Theme.gradient4 }
    		GradientStop { position: 1; color: Theme.gradient5 }
	}

	readonly property Gradient inactiveGradient: RadialGradient {
		focalX: 0
		focalY: 0
		centerRadius: 100
		GradientStop { position: 0; color: Theme.bg }
	}

	function statusColor(state) {
		switch (state) {
			case "charging": return Theme.positive
			case "warning": return Theme.warn
			case "critical": return Theme.notify
			case "unknown": return Theme.textMuted
			default: return Theme.text
		}
	}

	Variants {
		model: Quickshell.screens

		Scope {
			required property var modelData

			TrayMenu {
				id: trayMenu
				screen: modelData
			}

			PanelWindow {
				id: bar

				screen: modelData
				visible: root.toggleVisible
				color: Theme.bg
				implicitHeight: barHeight

				exclusiveZone: implicitHeight

				anchors {
					left: true
					top: true
					right: true
				}

				// Bottom border
				Rectangle {
					anchors {
						left: parent.left
						right: parent.right
						bottom: parent.bottom
					}

					height: 1
					color: Theme.border
				}

				// Workspaces
				Workspaces {
					id: workspaces
					monitorName: modelData.name
				}

				Row {
					id: workspaceRow

					anchors {
						left: parent.left
						leftMargin: margin
						verticalCenter: parent.verticalCenter
					}

					spacing: workspaceSpacing

					Repeater {
						model: workspaces.list

						delegate: Shape {
							id: wsPill

							required property var modelData

							readonly property bool active: modelData === workspaces.active

							width: pillWidth + (active ? extendActive : 0)
							height: pillHeight

							antialiasing: true

							Behavior on width {
								NumberAnimation {
									duration: 300
									easing.type: Easing.InOutQuad
								}
							}

							ShapePath {
								fillGradient: wsPill.active ? activeGradient : inactiveGradient
								strokeColor: Theme.border
								strokeWidth: 1

								startX: 0
								startY: wsPill.height

								PathLine {
									x: wsPill.width
									y: wsPill.height
								}
								PathLine {
									x: wsPill.width
									y: 0
								}
								PathLine {
									x: 0
									y: 0
								}
								PathLine {
									x: 0
									y: wsPill.height
								}
							}

							Text {
								anchors.centerIn: parent
								text: workspaces.iconForWorkspace(wsPill.modelData)
								font.family: Theme.fontFamily
								font.pixelSize: Theme.fontSizeNormal
								color: wsPill.active ? Theme.bg : Theme.text
							}
						}
					}
				}

				// Clock widget
				Text {
					id: clock

					anchors {
						right: parent.right
						rightMargin: margin
						verticalCenter: parent.verticalCenter
					}

					text: Time.time
					font.family: Theme.fontFamily
					font.pixelSize: Theme.fontSizeLarge
					color: Theme.text
				}

				// Divider to the left of clock widget
				Rectangle {
					id: clockDivider

					anchors {
						right: clock.left
						rightMargin: margin
						verticalCenter: parent.verticalCenter
					}

					width: 1
					height: barHeight
					color: Theme.border
				}

				// Declare battery status
				BatteryStatus {
					id: batteryStatus
				}

				// Battery widget
				Row {
					id: battery

					anchors {
						right: clockDivider.left
						rightMargin: margin
						verticalCenter: parent.verticalCenter
					}

					spacing: widgetMargin

					Text {
						text: batteryStatus.icon
						font.family: Theme.fontFamily
						font.pixelSize: Theme.fontSizeLarge
						color: root.statusColor(batteryStatus.state)
					}

					Text {
						text: batteryStatus.label
						font.family: Theme.fontFamily
						font.pixelSize: Theme.fontSizeLarge
						color: root.statusColor(batteryStatus.state)
					}
				}

				// Declare CPU temperature
				CpuTemperature {
					id: cpuTemperature
				}

				// CPU temperature widget
				Row {
					id: cpu

					anchors {
						right: battery.left
						rightMargin: margin
						verticalCenter: parent.verticalCenter
					}

					spacing: widgetMargin

					Text {
						text: cpuTemperature.icon
						font.family: Theme.fontFamily
						font.pixelSize: Theme.fontSizeLarge
						color: root.statusColor(cpuTemperature.state)
					}

					Text {
						text: cpuTemperature.label
						font.family: Theme.fontFamily
						font.pixelSize: Theme.fontSizeLarge
						color: root.statusColor(cpuTemperature.state)
					}
				}

				// Declare wifi status
				WifiStatus {
					id: wifiStatus
				}

				// Wifi status widget
				Text {
					id: wifi

					anchors {
						right: cpu.left
						rightMargin: margin
						verticalCenter: parent.verticalCenter
					}

					text: wifiStatus.icon
					font.family: Theme.fontFamily
					font.pixelSize: Theme.fontSizeLarge
					color: wifiStatus.state === "disconnected" ? Theme.warn : Theme.text
				}

				// Diagonal seperator
				Shape {
					id: dividerWifi

					anchors {
						right: wifi.left
						rightMargin: margin
						verticalCenter: parent.verticalCenter
					}

					width: seperatorWidth
					height: barHeight

					antialiasing: true

					ShapePath {
						strokeColor: Theme.border
						strokeWidth: 1
						startX: seperatorWidth
						startY: 0
						PathLine {
							x: 0
							y: barHeight
						}
					}
				}

				// Declare tray status
				SystemTray {
					id: systemTray
				}

				// System tray
				Row {
					id: tray

					anchors {
						right: dividerWifi.left
						rightMargin: margin
						verticalCenter: parent.verticalCenter
					}

					spacing: margin

					Repeater {
						model: systemTray.items

						delegate: Item {
							id: trayEntry

							required property var modelData

							width: trayEntrySize
							height: trayEntrySize

							Image {
								anchors.fill: parent
								source: trayEntry.modelData.icon
								sourceSize.width: trayEntrySize
								sourceSize.height: trayEntrySize
								fillMode: Image.PreserveAspectFit
								smooth: true
								asynchronous: true
							}

							MouseArea {
								anchors.fill: parent
								acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
								cursorShape: Qt.PointingHandCursor

								onClicked: (mouse) => {
									if (mouse.button === Qt.LeftButton) {
										systemTray.activate(trayEntry.modelData)
									} else if (mouse.button === Qt.MiddleButton) {
										systemTray.secondaryActivate(trayEntry.modelData)
									} else {
										trayMenu.entry = trayEntry.modelData
										trayMenu.menuX = trayEntry.mapToItem(null, 0, trayEntry.height).x
										trayMenu.menuY = trayEntry.mapToItem(null, 0, trayEntry.height).y
									}
								}
							}
						}
					}
				}

				// Diagonal seperator
				Shape {
					id: dividerTray

					anchors {
						right: tray.left
						rightMargin: margin
						verticalCenter: parent.verticalCenter
					}

					width: seperatorWidth
					height: barHeight

					visible: systemTray.count > 0
					antialiasing: true

					ShapePath {
						strokeColor: Theme.border
						strokeWidth: 1
						startX: seperatorWidth
						startY: 0
						PathLine {
							x: 0
							y: barHeight
						}
					}
				}
			}
		}
	}
}
