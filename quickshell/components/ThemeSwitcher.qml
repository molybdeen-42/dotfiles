import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import "../themes"

Scope {
	id: root

	property bool open: false
	property string selectorScreen: "eDP-1"
	readonly property var themes: ["blindfold", "copper", "forest", "city", "frog", "mirror", "moon"]
	property int selectedIndex: 0
	property string currentTheme: ""

	readonly property real cardHeightRatio: 0.5
	readonly property int sliceGap: 24
	readonly property real sliceWidth: 0.45
	readonly property real sliceSlant: 0.18
	readonly property real sliceScale: 0.7

	GlobalShortcut {
		name: "themeSwitcher"
		onPressed: () => {
			if (!root.open && Hyprland.focusedMonitor) {
				root.selectorScreen = Hyprland.focusedMonitor.name

				const i = root.themes.indexOf(root.currentTheme)
				if (i >= 0)
					root.selectedIndex = i
			}

			root.open = !root.open
		}
	}

	FileView {
		path: Quickshell.env("HOME") + "/.config/themes/current_theme.txt"
		watchChanges: true
		onLoaded: root.currentTheme = this.text().trim()
		onFileChanged: this.reload()
	}

	Process {
		id: themeSwitcher
		command: [
			"bash",
			Quickshell.env("HOME") + "/.config/themes/change_theme.sh",
			root.themes[root.selectedIndex]
		]
	}

	Variants {
		model: Quickshell.screens

		PanelWindow {
			id: panel

			required property var modelData

			screen: modelData
			visible: root.open
			color: "transparent"
			exclusiveZone: -1
			focusable: true

			anchors {
				left: true
				right: true
				top: true
				bottom: true
			}

			onVisibleChanged: {
				if (visible)
					keySink.forceActiveFocus()
			}

			Rectangle {
				anchors.fill: parent
				color: "#73000000"
			}

			Item {
				id: keySink
				anchors.fill: parent
				focus: true
				Keys.onEscapePressed: root.open = false

				Keys.onPressed: (event) => {
					if (event.key === Qt.Key_Left || event.key === Qt.Key_H)
						root.selectedIndex = (root.selectedIndex + root.themes.length - 1) % root.themes.length
					else if (event.key === Qt.Key_Right || event.key === Qt.Key_L)
						root.selectedIndex = (root.selectedIndex + 1) % root.themes.length
					else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
						themeSwitcher.startDetached()
						root.open = false
					}
				}
			}

			Loader {
				anchors.fill: parent
				active: modelData.name === root.selectorScreen

				sourceComponent: Component {
					Item {
						id: carousel
						anchors.fill: parent

						readonly property real cardWidth: Math.min(
							panel.height * root.cardHeightRatio * 3 / 2,
							(panel.width / 2 - root.sliceGap - 24) / (0.5 + root.sliceWidth * root.sliceScale)
						)

						Repeater {
							model: root.themes

							delegate: Item {
								id: card

								required property string modelData
								readonly property int index: root.themes.indexOf(card.modelData)
								readonly property bool isSelected: index === root.selectedIndex

								readonly property int offset: {
									const length = root.themes.length
									const div = (index + length - root.selectedIndex) % length
									return div > length / 2 ? div - length : div
								}

								property real band: isSelected ? 1.0 : root.sliceWidth
								property real slant: isSelected ? 0.0 : root.sliceSlant
								property real bandPos: isSelected ? 0.0
									: (offset < 0 ? 1.0 - root.sliceWidth - root.sliceSlant : 0.0)

								width: carousel.cardWidth
								height: width * 2 / 3

								readonly property real centerOffset: {
									if (offset > 1)
										return carousel.width / 2 + width / 2 + root.sliceGap / 2
									if (offset < -1)
										return -carousel.width / 2 - width / 2 - root.sliceGap / 2
									return offset * (width * (1 + root.sliceScale) / 2 + root.sliceGap)
								}

								readonly property real targetX: carousel.width / 2 - width / 2 + centerOffset

								x: targetX
								y: carousel.height / 2 - height / 2

								z: -Math.abs(offset)
								scale: isSelected ? 1.0 : root.sliceScale

								onOffsetChanged: {
									if (Math.abs(offset) > 1) {
										x = (x + width / 2 < carousel.width / 2)
											? Qt.binding(() => -width * (1 + root.sliceScale) / 2 - root.sliceGap / 2)
											: Qt.binding(() => carousel.width + root.sliceGap / 2)
										return
									}

									if ((offset === -1 && x + width / 2 > carousel.width / 2)
										|| (offset === 1 && x + width / 2 < carousel.width / 2)) {
										xBehavior.enabled = false
										x = (offset === -1)
											? -width * (1 + root.sliceScale) / 2 - root.sliceGap / 2
											: carousel.width + root.sliceGap / 2
										xBehavior.enabled = true
									}

									x = Qt.binding(() => targetX)
								}

								Shape {
									id: sliceMask
									visible: true
									x: card.width * 4 / card.scale
									width: card.width
									height: card.height

									ShapePath {
										strokeWidth: 0
										fillColor: "#ffffff"

										startX: (card.bandPos + card.slant) * card.width
										startY: 0
										PathLine { x: (card.bandPos + card.band + card.slant) * card.width; y: 0 }
										PathLine { x: (card.bandPos + card.band) * card.width; y: card.height }
										PathLine { x: card.bandPos * card.width; y: card.height }
									}
								}

								ShaderEffectSource {
									id: sliceMaskSource
									sourceItem: sliceMask
									hideSource: true
									live: true
									x: card.width * 4 / card.scale
									width: sliceMask.width
									height: sliceMask.height
								}

								Image {
									id: preview

									anchors.fill: parent
									anchors.margins: 2
									fillMode: Image.PreserveAspectFit
									asynchronous: true
									source: "file://" + Quickshell.env("HOME")
										+ "/.config/themes/previews/" + card.modelData + ".png"

									layer.enabled: true
									layer.effect: OpacityMask {
										maskSource: sliceMaskSource
									}
								}

								Behavior on x {
									id: xBehavior
									NumberAnimation {
										duration: 400
										easing.type: Easing.InOutQuad
									}
								}

								Behavior on band {
									NumberAnimation {
										duration: 400
										easing.type: Easing.InOutQuad
									}
								}

								Behavior on slant {
									NumberAnimation {
										duration: 400
										easing.type: Easing.InOutQuad
									}
								}

								Behavior on bandPos {
									NumberAnimation {
										duration: 400
										easing.type: Easing.InOutQuad
									}
								}

								Behavior on scale {
									NumberAnimation {
										duration: 400
										easing.type: Easing.InOutQuad
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
