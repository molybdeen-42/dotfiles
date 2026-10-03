import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Shapes
import "../bar/widgets/data"
import "../themes"

Scope {
	id: root

	property bool open: false
	property string selectorScreen: "eDP-1"
	property bool devicesOpen: false
	property bool btOpen: false
	property int selectedMenu: 0
	property bool closing: false

	function close() {
		if (!open)
			return
		closing = true
		open = false
		closeTimer.restart()
	}

	Timer {
		id: closeTimer
		interval: 250
		onTriggered: root.closing = false
	}

	function sortedSinks() {
		const list = Audio.sinks.slice()
		const active = Music.audioDevice !== "" && Music.audioDevice !== "auto"
			? Music.audioDevice
			: Audio.defaultSink
		const i = list.findIndex(s => s.name === active)
		if (i > 0) {
			const item = list[i]
			list.splice(i, 1)
			list.unshift(item)
		}
		return list
	}

	Binding {
		target: Music
		property: "active"
		value: root.open
	}

	onOpenChanged: if (open) {
		Audio.refresh()
		Bluetooth.refresh()
	}

	GlobalShortcut {
		name: "musicMenu"
		onPressed: () => {
			if (!root.open && Hyprland.focusedMonitor) {
				root.selectorScreen = Hyprland.focusedMonitor.name
				root.closing = false
				root.open = true
			} else {
				root.close()
			}
		}
	}

	Variants {
		model: Quickshell.screens

		PanelWindow {
			id: panel

			required property var modelData

			readonly property int panelHeight: 260

			screen: modelData
			visible: root.open || root.closing
			color: "transparent"
			exclusiveZone: -1
			focusable: true
			implicitHeight: panelHeight

			anchors {
				left: true
				right: true
				bottom: true
			}

			onVisibleChanged: {
				if (visible && modelData.name === root.selectorScreen)
					keySink.forceActiveFocus()
			}

			MouseArea {
				anchors.fill: parent
				onClicked: root.close()
			}

			Item {
				id: keySink
				anchors.fill: parent
				focus: true
				Keys.onEscapePressed: root.close()
				Keys.onPressed: (event) => {
					switch (event.key) {
					case Qt.Key_Space:
						Music.toggle()
						break
					case Qt.Key_N:
						Music.next()
						break
					case Qt.Key_P:
						Music.prev()
						break
					case Qt.Key_L:
						Audio.setVolume(Audio.volume + 5)
						break
					case Qt.Key_H:
						Audio.setVolume(Audio.volume - 5)
						break
					case Qt.Key_A:
						if (root.devicesOpen) {
							root.devicesOpen = false
						} else {
							root.selectedMenu = 0
							Audio.refresh()
							root.devicesOpen = true
							root.btOpen = false
						}
						break
					case Qt.Key_B:
						if (root.btOpen) {
							root.btOpen = false
						} else {
							root.selectedMenu = 0
							Bluetooth.refresh()
							root.btOpen = true
							root.devicesOpen = false
						}
						break
					case Qt.Key_J: {
						if (root.devicesOpen || root.btOpen) {
							const count = root.devicesOpen ? Audio.sinks.length : Bluetooth.devices.length
							root.selectedMenu = (root.selectedMenu + 1) % count
						}
						break
					}
					case Qt.Key_K: {
						if (root.devicesOpen || root.btOpen) {
							const count = root.devicesOpen ? Audio.sinks.length : Bluetooth.devices.length
							root.selectedMenu = (root.selectedMenu + count - 1) % count
						}
						break
					}
					case Qt.Key_Return:
					case Qt.Key_Enter: {
						if (root.devicesOpen) {
							const device = root.sortedSinks()[root.selectedMenu]
							if (device) {
								Audio.setDefault(device.name)
								Music.setAudioDevice(device.name)
								root.devicesOpen = false
							}
						} else if (root.btOpen) {
							const device = Bluetooth.devices[root.selectedMenu]
							if (device)
								Bluetooth.toggle(device)
						}
						break
					}
					}
				}
			}

			Loader {
				anchors.fill: parent
				active: modelData.name === root.selectorScreen

				sourceComponent: Component {
					Item {
						anchors.fill: parent

					Rectangle {
						id: menuPanel

						readonly property int barWidth: 10
						readonly property int barGap: 6
						readonly property int visualWidth: Music.barCount * barWidth + (Music.barCount - 1) * barGap
						readonly property int visualHeight: 96
						readonly property int menuListHeight: 5 * 29 + 2
						readonly property int deviceColumnWidth: 190
						readonly property int playButtonSize: 40
						readonly property int skipButtonSize: 28
						readonly property int buttonGap: 24
						readonly property int columnGap: 12
						readonly property int columnMargin: 8

						readonly property Gradient playGradient: LinearGradient {
							x1: 0
							y1: 0
							x2: menuPanel.playButtonSize
							y2: 0
							GradientStop { position: 0; color: Theme.gradient1 }
							GradientStop { position: 0.25; color: Theme.gradient1 }
							GradientStop { position: 0.50; color: Theme.gradient2 }
							GradientStop { position: 0.75; color: Theme.gradient3 }
							GradientStop { position: 0.97; color: Theme.gradient4 }
							GradientStop { position: 1; color: Theme.gradient5 }
						}

						readonly property Gradient skipGradient: LinearGradient {
							x1: 0
							y1: 0
							x2: menuPanel.skipButtonSize
							y2: 0
							GradientStop { position: 0; color: Theme.gradient1 }
							GradientStop { position: 0.25; color: Theme.gradient1 }
							GradientStop { position: 0.50; color: Theme.gradient2 }
							GradientStop { position: 0.75; color: Theme.gradient3 }
							GradientStop { position: 0.97; color: Theme.gradient4 }
							GradientStop { position: 1; color: Theme.gradient5 }
						}

						readonly property Gradient chipGradient: LinearGradient {
							x1: 0
							y1: 0
							x2: menuPanel.deviceColumnWidth
							y2: 0
							GradientStop { position: 0; color: Theme.gradient1 }
							GradientStop { position: 0.25; color: Theme.gradient1 }
							GradientStop { position: 0.50; color: Theme.gradient2 }
							GradientStop { position: 0.75; color: Theme.gradient3 }
							GradientStop { position: 0.97; color: Theme.gradient4 }
							GradientStop { position: 1; color: Theme.gradient5 }
						}

						readonly property Gradient listGradient: LinearGradient {
							x1: 0
							y1: 0
							x2: menuPanel.visualWidth
							y2: 0
							GradientStop { position: 0; color: Theme.gradient1 }
							GradientStop { position: 0.25; color: Theme.gradient1 }
							GradientStop { position: 0.50; color: Theme.gradient2 }
							GradientStop { position: 0.75; color: Theme.gradient3 }
							GradientStop { position: 0.97; color: Theme.gradient4 }
							GradientStop { position: 1; color: Theme.gradient5 }
						}

						function barColor(index) {
							const stops = [Theme.gradient1, Theme.gradient2, Theme.gradient3, Theme.gradient4, Theme.gradient5]
							const t = index / (Music.barCount - 1) * (stops.length - 1)
							const i0 = Math.floor(t)
							const i1 = Math.min(i0 + 1, stops.length - 1)
							const f = t - i0
							return Qt.rgba(
								stops[i0].r + (stops[i1].r - stops[i0].r) * f,
								stops[i0].g + (stops[i1].g - stops[i0].g) * f,
								stops[i0].b + (stops[i1].b - stops[i0].b) * f,
								1
							)
						}

						width: visualWidth + 2 * columnMargin
						height: panel.panelHeight
						color: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.9)

						property real slideOffset: root.open ? 0 : panel.panelHeight

						anchors.horizontalCenter: parent.horizontalCenter
						anchors.bottom: parent.bottom
						anchors.bottomMargin: -slideOffset

						Behavior on slideOffset {
							NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
						}

						Rectangle {
							anchors {
								top: parent.top
								left: parent.left
								right: parent.right
							}

							height: 1
							color: Theme.border
						}

						Rectangle {
							anchors {
								top: parent.top
								bottom: parent.bottom
								left: parent.left
							}

							width: 1
							color: Theme.border
						}

						Rectangle {
							anchors {
								top: parent.top
								bottom: parent.bottom
								right: parent.right
							}

							width: 1
							color: Theme.border
						}

						MouseArea {
							anchors.fill: parent
						}

						Column {
							id: playerColumn

							width: visualiser.width
							spacing: 16
							anchors {
								left: parent.left
								leftMargin: menuPanel.columnMargin
								bottom: parent.bottom
								bottomMargin: 8
							}

							Item {
								id: titleClip

								readonly property bool overflowing: titleText.implicitWidth > visualiser.width

								width: overflowing ? visualiser.width : titleText.implicitWidth
								height: titleText.implicitHeight
								clip: true
								anchors.horizontalCenter: parent.horizontalCenter

								onOverflowingChanged: if (!overflowing) titleText.x = 0

								Text {
									id: titleText
									anchors.verticalCenter: parent.verticalCenter
									text: Music.title
									color: Theme.text
									font.family: Theme.fontFamily
									font.pixelSize: Theme.fontSizeLarge
								}

								SequentialAnimation {
									running: Music.playing && titleClip.overflowing
									loops: Animation.Infinite

									PauseAnimation { duration: 1500 }

									NumberAnimation {
										target: titleText
										property: "x"
										to: titleClip.width - titleText.implicitWidth
										duration: Math.max(0, titleText.implicitWidth - titleClip.width) * 40
										easing.type: Easing.InOutQuad
									}

									PauseAnimation { duration: 1500 }

									NumberAnimation {
										target: titleText
										property: "x"
										to: 0
										duration: Math.max(0, titleText.implicitWidth - titleClip.width) * 40
										easing.type: Easing.InOutQuad
									}
								}
							}

							Item {
								id: visualiser

								width: menuPanel.visualWidth
								height: menuPanel.visualHeight

								Repeater {
									model: Music.barCount

									delegate: Rectangle {
										required property int index

										readonly property real value: Music.bars[index] ?? 0

										x: index * (menuPanel.barWidth + menuPanel.barGap)
										width: menuPanel.barWidth
										anchors.bottom: parent.bottom
										height: 4 + value * (menuPanel.visualHeight - 4)
										radius: 2
										color: menuPanel.barColor(index)
									}
								}
							}

							Item {
								width: menuPanel.visualWidth
								height: menuPanel.playButtonSize

							Item {
								id: volumeSlider

								width: parent.width - 16 - menuPanel.playButtonSize - 2 * (menuPanel.skipButtonSize + menuPanel.buttonGap)
								height: parent.height
								anchors.left: parent.left

								Text {
									id: volumeGlyph
									text: {
										const v = Audio.volume
										if (v <= 0)
											return "󰸈"
										if (v < 33)
											return "󰕿"
										if (v < 66)
											return "󰖀"
										return "󰕾"
									}
									color: Theme.textMuted
									font.family: Theme.fontFamily
									font.pixelSize: 32
									anchors.left: parent.left
									anchors.verticalCenter: parent.verticalCenter
								}

								Rectangle {
									id: volumeTrack
									height: 6
									radius: 3
									color: Theme.border
									anchors.left: volumeGlyph.right
									anchors.leftMargin: 4
									anchors.right: parent.right
									anchors.rightMargin: 4
									anchors.verticalCenter: parent.verticalCenter

									Rectangle {
										width: Math.min(parent.width, parent.width * Audio.volume / 100)
										height: parent.height
										radius: 2
										color: Theme.accent
									}

									Rectangle {
										id: volumeHandle
										width: 10
										height: 10
										radius: 5
										color: Theme.text
										x: Math.max(0, Math.min(parent.width - width, (parent.width - width) * Audio.volume / 100))
										anchors.verticalCenter: parent.verticalCenter
									}
								}

								MouseArea {
									anchors.fill: parent
									cursorShape: Qt.PointingHandCursor
									function apply(x) {
										const left = volumeGlyph.width + 4
										const value = Math.round(Math.max(0, Math.min(100, (x - left) / volumeTrack.width * 100)))
										Audio.setVolume(value)
									}
									onPressed: (mouse) => apply(mouse.x)
									onPositionChanged: (mouse) => {
										if (pressed)
											apply(mouse.x)
									}
								}
							}

							Item {
								width: menuPanel.playButtonSize + 2 * (menuPanel.skipButtonSize + menuPanel.buttonGap)
								height: menuPanel.playButtonSize
								anchors.right: parent.right

								Shape {
									id: prevButton
									width: menuPanel.skipButtonSize
									height: menuPanel.skipButtonSize
									anchors.left: parent.left
									anchors.verticalCenter: parent.verticalCenter
									antialiasing: true

									ShapePath {
										strokeColor: Theme.border
										strokeWidth: 1
										fillGradient: menuPanel.skipGradient

										startX: 0
										startY: 0
										PathLine { x: prevButton.width; y: 0 }
										PathLine { x: prevButton.width; y: prevButton.height }
										PathLine { x: 0; y: prevButton.height }
										PathLine { x: 0; y: 0 }
									}

									Text {
										anchors.centerIn: parent
										text: "󰒮"
										color: Theme.bg
										font.family: Theme.fontFamily
										font.pixelSize: 14
									}

									MouseArea {
										anchors.fill: parent
										cursorShape: Qt.PointingHandCursor
										onClicked: Music.prev()
									}
								}

								Shape {
									id: playButton
									width: menuPanel.playButtonSize
									height: menuPanel.playButtonSize
									anchors.horizontalCenter: parent.horizontalCenter
									anchors.verticalCenter: parent.verticalCenter
									antialiasing: true

									ShapePath {
										strokeColor: Theme.border
										strokeWidth: 1
										fillGradient: menuPanel.playGradient

										startX: 0
										startY: 0
										PathLine { x: playButton.width; y: 0 }
										PathLine { x: playButton.width; y: playButton.height }
										PathLine { x: 0; y: playButton.height }
										PathLine { x: 0; y: 0 }
									}

									Text {
										anchors.centerIn: parent
										text: Music.playing ? "󰏤" : "󰐊"
										color: Theme.bg
										font.family: Theme.fontFamily
										font.pixelSize: 32
									}

									MouseArea {
										anchors.fill: parent
										cursorShape: Qt.PointingHandCursor
										onClicked: Music.toggle()
									}
								}

								Shape {
									id: nextButton
									width: menuPanel.skipButtonSize
									height: menuPanel.skipButtonSize
									anchors.right: parent.right
									anchors.verticalCenter: parent.verticalCenter
									antialiasing: true

									ShapePath {
										strokeColor: Theme.border
										strokeWidth: 1
										fillGradient: menuPanel.skipGradient

										startX: 0
										startY: 0
										PathLine { x: nextButton.width; y: 0 }
										PathLine { x: nextButton.width; y: nextButton.height }
										PathLine { x: 0; y: nextButton.height }
										PathLine { x: 0; y: 0 }
									}

									Text {
										anchors.centerIn: parent
										text: "󰒭"
										color: Theme.bg
										font.family: Theme.fontFamily
										font.pixelSize: 14
									}

									MouseArea {
										anchors.fill: parent
										cursorShape: Qt.PointingHandCursor
										onClicked: Music.next()
									}
								}
							}
							}
						}

						Item {
							id: deviceColumn

							width: menuPanel.visualWidth
							height: 34
							anchors {
								horizontalCenter: parent.horizontalCenter
								top: parent.top
								topMargin: 8
							}

							Shape {
								id: deviceChip

								width: (parent.width - 16) / 2
								height: 34
								anchors.left: parent.left
								antialiasing: true

								ShapePath {
									strokeColor: Theme.border
									strokeWidth: 1
									fillGradient: menuPanel.chipGradient

									startX: 0
									startY: 0
									PathLine { x: deviceChip.width; y: 0 }
									PathLine { x: deviceChip.width; y: deviceChip.height }
									PathLine { x: 0; y: deviceChip.height }
									PathLine { x: 0; y: 0 }
								}

								Text {
									id: chipGlyph
									text: "󰕾"
									color: Theme.bg
									font.family: Theme.fontFamily
									font.pixelSize: 16
									anchors.left: parent.left
									anchors.leftMargin: 4
									anchors.verticalCenter: parent.verticalCenter
								}

								Text {
									text: Audio.sinks.find(s => s.name === deviceList.activeSink)?.description ?? "Devices"
									color: Theme.bg
									font.family: Theme.fontFamily
									font.pixelSize: Theme.fontSizeLarge
									elide: Text.ElideRight
									anchors.left: chipGlyph.right
									anchors.leftMargin: 4
									anchors.right: parent.right
									anchors.rightMargin: 4
									anchors.verticalCenter: parent.verticalCenter
								}

								MouseArea {
									anchors.fill: parent
									cursorShape: Qt.PointingHandCursor
									onClicked: {
										Audio.refresh()
										root.selectedMenu = 0
										root.devicesOpen = !root.devicesOpen
										root.btOpen = false
									}
								}
							}

							Shape {
								id: btChip

								width: (parent.width - 16) / 2
								height: 34
								anchors.right: parent.right
								antialiasing: true

								ShapePath {
									strokeColor: Theme.border
									strokeWidth: 1
									fillGradient: menuPanel.chipGradient

									startX: 0
									startY: 0
									PathLine { x: btChip.width; y: 0 }
									PathLine { x: btChip.width; y: btChip.height }
									PathLine { x: 0; y: btChip.height }
									PathLine { x: 0; y: 0 }
								}

								Text {
									id: btGlyph
									text: "󰂱"
									color: Theme.bg
									font.family: Theme.fontFamily
									font.pixelSize: 16
									anchors.left: parent.left
									anchors.leftMargin: 4
									anchors.verticalCenter: parent.verticalCenter
								}

								Text {
									text: Bluetooth.devices.find(d => d.connected)?.name ?? "Bluetooth"
									color: Theme.bg
									font.family: Theme.fontFamily
									font.pixelSize: Theme.fontSizeLarge
									elide: Text.ElideRight
									anchors.left: btGlyph.right
									anchors.leftMargin: 4
									anchors.right: parent.right
									anchors.rightMargin: 4
									anchors.verticalCenter: parent.verticalCenter
								}

								MouseArea {
									anchors.fill: parent
									cursorShape: Qt.PointingHandCursor
									onClicked: {
										Bluetooth.refresh()
										root.selectedMenu = 0
										root.btOpen = !root.btOpen
										root.devicesOpen = false
									}
								}
							}

							Rectangle {
								z: 1
								visible: root.btOpen
								width: parent.width
								height: menuPanel.menuListHeight
								anchors.top: btChip.bottom
								color: Theme.bg
								border.width: 1
								border.color: Theme.border
							}

							ListView {
								id: btList
								z: 2

								visible: root.btOpen
								width: parent.width
								height: menuPanel.menuListHeight
								anchors.top: btChip.bottom
								clip: true
								spacing: 2
								boundsBehavior: Flickable.StopAtBounds
								model: Bluetooth.devices

								onVisibleChanged: if (visible)
									positionViewAtIndex(root.selectedMenu, ListView.Contain)

								Connections {
									target: root
									function onSelectedMenuChanged() {
										btList.positionViewAtIndex(root.selectedMenu, ListView.Contain)
									}
								}

								delegate: Rectangle {
									id: btDelegate

									required property var modelData
									required property int index

									width: btList.width
									height: 27
									color: "transparent"

									Shape {
										id: btBg
										anchors.fill: parent
										visible: btMouse.containsMouse || (root.btOpen && root.selectedMenu === btDelegate.index)
										antialiasing: true

										ShapePath {
											strokeWidth: 0
											fillGradient: menuPanel.listGradient

											startX: 0
											startY: 0
											PathLine { x: btBg.width; y: 0 }
											PathLine { x: btBg.width; y: btBg.height }
											PathLine { x: 0; y: btBg.height }
											PathLine { x: 0; y: 0 }
										}
									}

									Text {
										anchors {
											left: parent.left
											leftMargin: 4
											verticalCenter: parent.verticalCenter
										}
										width: parent.width - 8
										text: (btDelegate.modelData.connected ? "󰄲  " : "") + btDelegate.modelData.name
										elide: Text.ElideRight
										font.family: Theme.fontFamily
										font.pixelSize: Theme.fontSizeNormal
										color: (btMouse.containsMouse || (root.btOpen && root.selectedMenu === btDelegate.index)) ? Theme.bg
											: (btDelegate.modelData.connected ? Theme.accent : Theme.text)
									}

									MouseArea {
										id: btMouse
										anchors.fill: parent
										hoverEnabled: true
										cursorShape: Qt.PointingHandCursor
										onClicked: Bluetooth.toggle(btDelegate.modelData)
									}
								}
							}

							Rectangle {
								z: 1
								visible: root.devicesOpen
								width: parent.width
								height: menuPanel.menuListHeight
								anchors.top: deviceChip.bottom
								color: Theme.bg
								border.width: 1
								border.color: Theme.border
							}

							ListView {
								id: deviceList
								z: 2

								readonly property string activeSink:
									Music.audioDevice !== "" && Music.audioDevice !== "auto"
									? Music.audioDevice
									: Audio.defaultSink

								visible: root.devicesOpen
								width: parent.width
								height: menuPanel.menuListHeight
								anchors.top: deviceChip.bottom
								clip: true
								spacing: 2
								boundsBehavior: Flickable.StopAtBounds
								model: root.sortedSinks()

								onVisibleChanged: if (visible)
									positionViewAtIndex(root.selectedMenu, ListView.Contain)

								Connections {
									target: root
									function onSelectedMenuChanged() {
										deviceList.positionViewAtIndex(root.selectedMenu, ListView.Contain)
									}
								}

								delegate: Rectangle {
									id: deviceDelegate

									required property var modelData
									required property int index

									width: deviceList.width
									height: 27
									color: "transparent"

									Shape {
										id: delegateBg
										anchors.fill: parent
										visible: delegateMouse.containsMouse || (root.devicesOpen && root.selectedMenu === deviceDelegate.index)
										antialiasing: true

										ShapePath {
											strokeWidth: 0
											fillGradient: menuPanel.listGradient

											startX: 0
											startY: 0
											PathLine { x: delegateBg.width; y: 0 }
											PathLine { x: delegateBg.width; y: delegateBg.height }
											PathLine { x: 0; y: delegateBg.height }
											PathLine { x: 0; y: 0 }
										}
									}

									Text {
										anchors {
											left: parent.left
											leftMargin: 4
											verticalCenter: parent.verticalCenter
										}
										width: parent.width - 8
										text: (deviceDelegate.modelData.name === deviceList.activeSink ? "󰄲  " : "") + deviceDelegate.modelData.description
										elide: Text.ElideRight
										font.family: Theme.fontFamily
										font.pixelSize: Theme.fontSizeNormal
										color: (delegateMouse.containsMouse || (root.devicesOpen && root.selectedMenu === deviceDelegate.index)) ? Theme.bg
											: (deviceDelegate.modelData.name === deviceList.activeSink ? Theme.accent : Theme.text)
									}

									MouseArea {
										id: delegateMouse
										anchors.fill: parent
										hoverEnabled: true
										cursorShape: Qt.PointingHandCursor
										onClicked: {
											Audio.setDefault(deviceDelegate.modelData.name)
											Music.setAudioDevice(deviceDelegate.modelData.name)
											root.devicesOpen = false
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
